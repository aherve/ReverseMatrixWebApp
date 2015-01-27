module MyApi
  module Entities
    class User < Grape::Entity
      expose :id
      expose :name
      expose :image
    end
  end
end
