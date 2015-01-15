class LandMailer < ActionMailer::Base
  default from: "recherche-terrain@woodstack.io"

  def new_interesting_land(land)
    @url = land.url
    @price = land.price_in_euro
    @surface = land.surface_in_squared_meters
    @town_name = land.town_readable_name

    mail(to: "woodstack@woodstack.io", subject: '[recherche terrain] nouvelle annonce intéressante')
  end

  def new_land(land)

    mail(to: "woodstack@woodstack.io", subject: '[recherche terrain] nouvelle annonce de terrain disponible!')
  end
end
