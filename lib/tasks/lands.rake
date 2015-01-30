namespace :lands do
  @min_surf = 1_000

  desc "get terrain-construction lands"
  task terrain_construction: :environment do 
    puts "min_surf=#{@min_surf}"
    #terrain-construction
    puts "fetching lands from terrain-construction.com"
    nl = LandsScrapper::TerrainConstruction::Scrapper.new(min_surface: @min_surf, max_dist_from_paris: 900).new_lands
    nl.each{|l| puts "new land in #{l.town.readable_name}: #{l.surface_in_squared_meters}m² for #{l.price_in_euro} euros" if l.save and l.town_id.present?}

  end

  desc "get seloger.com lands"
  task seloger: :environment do 
    #se loger.com
    puts "min_surf=#{@min_surf}"
    puts "fetching lands from seloger.com"
    nl = LandsScrapper::SeLoger::Scrapper.new(min_surface: @min_surf).new_lands
    nl.each{|l| puts "new land in #{l.town.readable_name}: #{l.surface_in_squared_meters}m² for #{l.price_in_euro} euros" if l.save and l.town_id.present?}
  end

  desc "scrap the ouèbe to find new lands"
  task update: [:environment,:seloger,:terrain_construction]

end
