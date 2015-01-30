namespace :lands do
  @min_surf = 1_000

  desc "get terrain-construction lands"
  task terrain_construction: :environment do 
    puts "min_surf=#{@min_surf}"
    #terrain-construction
    puts "fetching lands from terrain-construction.com"
    tc = LandsScrapper::TerrainConstruction::Scrapper.new(min_surface: @min_surf, max_dist_from_paris: 900)
    tc.all_pages.each{|p| p.delay.save_new_lands!}

  end

  desc "get seloger.com lands"
  task seloger: :environment do 
    #se loger.com
    puts "min_surf=#{@min_surf}"
    puts "fetching lands from seloger.com"
    sl = LandsScrapper::SeLoger::Scrapper.new(min_surface: @min_surf)
    sl.all_pages.each{|p| p.delay.save_new_lands!}
  end

  desc "scrap the ouèbe to find new lands"
  task update: [:environment,:seloger,:terrain_construction]

end
