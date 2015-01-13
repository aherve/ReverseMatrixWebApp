namespace :lands do

  desc "scrap the ouèbe to find new lands"
  task update: :environment do
    
    #terrain-construction
    tc_lands = LandsScrapper::TerrainConstruction::Scrapper.new(min_surface: 35_000, max_dist_from_paris: 600).new_lands
    puts "#{tc_lands.count} new lands found from terrain-construction.com"
    tc_lands.each(&:save)

  end

end
