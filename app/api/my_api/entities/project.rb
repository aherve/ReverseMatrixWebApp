module MyApi
  module Entities
    class Project < Grape::Entity
      expose :id

      expose :new_lands, using: MyApi::Entities::Land
      expose :archived_lands, using: MyApi::Entities::Land
      expose :favorite_lands, using: MyApi::Entities::Land
    end
  end
end
