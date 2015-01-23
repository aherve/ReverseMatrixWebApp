require 'open-uri'
require 'nokogiri'

module LandsScrapper
  module SeLoger
    class Scrapper < LandsScrapper::Scrapper

      attr_accessor :pages

      def initialize(params={})
        @pages = Hash.new do |h,department|
          h[department] = Hash.new do |hh,i|
            hh[i] = get_page(department,i)
          end
        end
        super
      end

      def get_page(dep,i)
        Nokogiri::HTML(
          open(
            "http://www.seloger.com/list.htm?cp=#{dep}&idtt=2&idtypebien=4.json&LISTING-LISTpg=#{i}"
          )
        )
      end

      def number_of_pages(dep)
        text = @pages[dep][1].xpath(".//p[contains(@class,'pagination_result_number')]").text
        nb_annonces = text.split(" ").first.to_i
        i,j = nb_annonces_per_page = text.split(" ").last.scan(/([0-9]+)/).map(&:first).map(&:to_i)
        nb_annonces_per_page = j - i + 1
        return (nb_annonces / nb_annonces_per_page.to_f).ceil
      end

      def all_pages
        Town.distinct(:department).lazy.flat_map do |dep|
          (1..number_of_pages(dep)).lazy.map do |i|
            pages[dep][i]
          end
        end
      end

      # extract lands from page
      def to_lands
        @lands ||= lambda { |nokogiri_page|
          nokogiri_page.xpath(".//article[contains(@class,'listing')]").map do |p|
            h = {
              provider: :seloger,
              price_in_euro: (p.xpath(".//a[contains(@class,'amount')]").first.text.gsub(/\D/,'').to_i rescue nil),
              locality: (p.xpath(".//h2//span").text rescue nil),
              surface_in_squared_meters: (p.xpath(".//ul[contains(@class,'property_list')]//li").last.text.to_i rescue nil),
              description: (p.xpath(".//p[contains(@class,'description')]").first.text.chomp.strip rescue nil),
              url: (p.xpath(".//h2//a").first.attributes["href"].value rescue nil),
              img: (p.xpath(".//div[contains(@class,'listing_photo_container')]//img").first.attributes["src"].value rescue nil),
            } 
          end
        }
      end

      def with_town
        @with_town ||= lambda {|h|
          h.merge({
            town_id: (Town.find_by_approximate_name(h[:locality]).id rescue nil)
          })
        }
      end

      def to_land
        @to_land ||= lambda {|h|
          Land.new(
            h.slice(
              :provider,
              :price_in_euro,
              :surface_in_squared_meters,
              :description,
              :url,
              :town_id,
              :img,
            )
          )
        }
      end

      def lands
        all_pages
        .flat_map(&to_lands)
        .select{|h| h[:surface_in_squared_meters] >= @min_surface}
        .map(&with_town)
        .map(&to_land)
      end

      def new_lands
        all_pages
        .flat_map(&to_lands)
        .select{|h| (h[:surface_in_squared_meters] >= @min_surface) rescue nil}
        .reject{|h| Land.where(url: h[:url]).exist?}
        .map(&with_town)
        .map(&to_land)
      end

    end
  end
end
