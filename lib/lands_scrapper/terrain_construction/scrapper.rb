require 'open-uri'
require 'nokogiri'

module LandsScrapper
  module TerrainConstruction
    class Scrapper < LandsScrapper::Scrapper

      attr_accessor :pages

      def initialize(params)

        @pages = Hash.new do |h,k|
          h[k] = get_page(k)
        end

        super

      end

      def number_of_pages
        nb = pages[0].xpath("//li[contains(@class,'pager-last')]//a").first.attributes["href"].to_s.scan(/page=([0-9]+)/).first.first.to_i
        puts "[terrain-construction] found #{nb} pages of results"
        nb
      end

      def get_page(i)
        raise "please provide an integer as argument" unless i.is_a? Integer
        puts "[terrain-construction] fetching page #{i}"
        Nokogiri::HTML(
          open(
            "http://www.terrain-construction.com/search/terrain-a-vendre/Paris-75000/75-Paris?page=#{i}&rayon=#{max_dist_from_paris}&terrain=1%252C0&ordre=prix&superficie=#{min_surface}"
          )
        )
      end

      def all_pages
        (0..number_of_pages).lazy.map do |i|
          pages[i]
        end
      end

      def to_raw_lands
        @to_lands ||= lambda { |nokogiri_page|
          nokogiri_page.xpath("//div[contains(@class,'node-annonce')]").to_a
        }
      end

      def to_formatted_land
        @to_formatted_land ||= lambda { |raw_land|
          h = {
            provider: :terrain_construction,
            price_in_euro: (raw_land.xpath(".//div[contains(@class,'group-left')]//span[contains(@class,'prix')]").first.text.gsub(" ","_").to_i rescue nil),
            locality: (raw_land.xpath(".//span[contains(@class,'locality')]").first.text rescue nil),
            postal_code: (raw_land.xpath(".//span[contains(@class,'postal-code')]").first.text.to_i rescue nil),
            department: (raw_land.xpath(".//span[contains(@class,'postal-code')]").first.text.to_i / 1000 rescue nil),
            surface_in_squared_meters: (raw_land.xpath(".//span[contains(@class,'superficie')]").first.text.gsub(" ",'').scan(/([0-9]+)/).first.first.to_i rescue nil),
            description: (raw_land.xpath(".//h3[contains(@class,'plus')]").first.text rescue nil),
            url: ("http://www.terrain-construction.com" << raw_land.xpath(".//div[contains(@class,'group-footer')]//a").first.attributes["href"].value rescue nil),
            img: ( raw_land.xpath(".//div[contains(@class,'result-photo')]//img").first.attributes["src"].value rescue nil),
          }
        }
      end

      def with_town
        @with_town ||= lambda {|formatted_land_hash|
          formatted_land_hash.merge({
            town_id: (Town.where_autocomplete(formatted_land_hash[:locality]).find_by(department: formatted_land_hash[:department]).id rescue nil)
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
        .flat_map(&to_raw_lands)
        .map(&to_formatted_land)
        .map(&with_town)
        .map(&to_land)
      end

      def new_lands
        all_pages
        .flat_map(&to_raw_lands)
        .map(&to_formatted_land)
        .reject{|h| Land.where(url: h[:url]).exists?}
        .map(&with_town)
        .map(&to_land)
      end

    end
  end
end
