require 'open-uri'
require 'nokogiri'

module LandsScrapper
  module TerrainConstruction
    class Scrapper < LandsScrapper::Scrapper

      attr_accessor :pages

      def initialize(params)

        super

      end

    end
  end
end
