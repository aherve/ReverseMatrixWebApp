module MyApi
  module Entities
    class Land < Grape::Entity
      expose :id

      expose :price_in_euro
      expose :surface_in_squared_meters
      expose :description
      expose :url
      expose :provider
      expose :archived
      expose :interesting
      expose :active_url

      expose :town_population
      expose :town_department
      expose :town_codename
      expose :town_readable_name
      expose :town_distance_value
      expose :town_car_travel_time_value
      expose :town_car_travel_time_text

      expose :created_at

    end
  end
end
