namespace :lands do

  desc "scrap the ouèbe to find new lands"
  task update: :environment do

    @min_surf = 400
    
    #terrain-construction
    puts "fetching lands from terrain-construction.com"
    nl = LandsScrapper::TerrainConstruction::Scrapper.new(min_surface: @min_surf, max_dist_from_paris: 900).new_lands
    nl.each{|l| puts "new land in #{l.town.readable_name}: #{l.surface_in_squared_meters}m² for #{l.price_in_euro} euros" if l.save and l.town_id.present?}

    #se loger.com
    puts "fetching lands from seloger.com"
    nl = LandsScrapper::SeLoger::Scrapper.new(min_surface: @min_surf).new_lands
    nl.each{|l| puts "new land in #{l.town.readable_name}: #{l.surface_in_squared_meters}m² for #{l.price_in_euro} euros" if l.save and l.town_id.present?}
  end

end
