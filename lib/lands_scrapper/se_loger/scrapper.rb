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
        LandsScrapper::SeLoger::Page.new(
          "http://www.seloger.com/list.htm?cp=#{dep}&idtt=2&idtypebien=4.json&LISTING-LISTpg=#{i}&surfacemin=#{@min_surface}"
        )
      end

      def number_of_pages(dep)
        @nb_of_pages ||= Hash.new do |h,dep|
          h[dep] = (
            text = @pages[dep][1].content.xpath(".//p[contains(@class,'pagination_result_number')]").text
            nb_annonces = text.split(" ").first.to_i
            nb = begin
                   i,j = nb_annonces_per_page = text.split(" ").last.scan(/([0-9]+)/).map(&:first).map(&:to_i)
                   nb_annonces_per_page = j - i + 1
                   (nb_annonces / nb_annonces_per_page.to_f).ceil
                 rescue
                   0
                 end
            puts "[seloger.com]: found #{nb} pages of results in department #{dep}" 
            nb
          )
        end
        @nb_of_pages[dep]
      end

      def all_pages
        Town.distinct(:department).lazy.flat_map do |dep|
          (1..number_of_pages(dep)).lazy.map do |i|
            pages[dep][i]
          end
        end
      end

    end
  end
end
