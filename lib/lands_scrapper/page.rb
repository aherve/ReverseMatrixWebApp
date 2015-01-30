module LandsScrapper
  #Abstract class
  class Page

    attr_reader :url
    def initialize(url)
      @url = url
    end

    def content
      @content ||= Nokogiri::HTML(open(url))
    end

    # specific to each provider
    def lands_hash
      []
    end

    def lands
      @lands ||= lands_hash.map do |h| 
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
      end
    end

    def new_lands
      lands.reject{|h| Land.where(url: h[:url]).exists?}
    end

    def save_new_lands!
      new_lands.map { |l|
        if l.town_id.present? and l.save
          puts "new land in #{l.town.readable_name}: #{l.surface_in_squared_meters}m² for #{l.price_in_euro} euros ( from #{l.provider}" 
          true
        end
      }
      .reduce(:&)
    end

  end
end
