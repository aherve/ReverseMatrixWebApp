module MyApi
  module Entities
    class Project < Grape::Entity
      expose :id

      expose :name
      expose :min_surface
      expose :max_surface
      expose :max_distance

      expose :new_lands_count
      expose :archived_lands_count
      expose :favorite_lands_count

      expose :town, using: MyApi::Entities::Town
    end
  end
end
