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

  end
end
