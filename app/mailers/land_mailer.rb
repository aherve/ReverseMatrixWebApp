class LandMailer < ActionMailer::Base
  default from: "aurelien@woodstack.io"

  def new_interesting_land(land)
    @url       = land.url
    @price     = land.price_in_euro
    @surface   = land.surface_in_squared_meters
    @town_name = land.town_readable_name
    @traject   = land.town.car_travel_time_text rescue 'unknown'

    mail(to: "aurelien@woodstack.io", subject: '[recherche terrain] annonce intéressante')
  end

  def new_land(land)
    @url       = land.url
    @price     = land.price_in_euro
    @surface   = land.surface_in_squared_meters
    @town_name = land.town_readable_name
    @traject   = land.town.car_travel_time_text rescue 'unknown'
    mail(to: "aurelien@woodstack.io", subject: '[recherche terrain] nouvelle annonce de terrain disponible!')
  end

end
