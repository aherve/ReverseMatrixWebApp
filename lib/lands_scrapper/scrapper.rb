require 'open-uri'
require 'nokogiri'
module LandsScrapper

  #abstract class
  class Scrapper
    attr_accessor :min_surface, :max_dist_from_paris

    def initialize(params)
      # surface in squared meters
      @min_surface = params[:min_surface] || params["min_surface"] || 10_000

      #dist in kilometers
      @max_dist_from_paris = params[:max_dist_from_paris] || params["max_dist_from_paris"] || 500
    end

    def delayed_saved_new_lands!
      all_pages.each do |p|
        p.delay.save_new_lands!
      end
    end

  end
end
