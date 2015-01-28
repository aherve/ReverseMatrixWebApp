module MyApi
  module Entities
    class Project < Grape::Entity
      expose :id

      expose :new_lands_count
      expose :archived_lands_count
      expose :favorite_lands_count
    end
  end
end
