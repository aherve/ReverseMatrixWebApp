namespace :lands do

  desc "scrap the ouèbe to find new lands"
  task update: :environment do

    @min_surf = 10_000
    
    #terrain-construction
    puts "fetching lands from terrain-construction.com"
    tc_lands = LandsScrapper::TerrainConstruction::Scrapper.new(min_surface: @min_surf, max_dist_from_paris: 800).new_lands
    puts "#{tc_lands.count} new lands found from terrain-construction.com"
    tc_lands.each(&:save)

    #se loger.com
    puts "fetching lands from seloger.com"
    nl = LandsScrapper::SeLoger::Scrapper.new(min_surface: @min_surf).new_lands
    puts "#{nl.count} new lands found from seloger.com"
    nl.each(&:save)
  end

end
