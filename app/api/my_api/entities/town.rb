module MyApi
  module Entities
    class Town < Grape::Entity
      expose :id
      expose :department           
      #expose :codename             
      expose :readable_name        
      expose :lat                  
      expose :lng                  
      expose :car_travel_time_value
      #expose :car_travel_time_text 

      expose :population

      #expose :distance_value       
      #expose :distance_text        
    end
  end
end
