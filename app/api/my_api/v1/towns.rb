module MyApi
  module V1
    class Towns < Grape::API
      format :json

      namespace :towns do 

        desc "get all towns for which the travel time is between t_min and t_max (please provide at least one of the two parameters)"
        params do 
          optional :t_min, type: Integer, desc: "minimum travel time in seconds"
          optional :t_max, type: Integer, desc: "maximum travel time in seconds"
        end
        get do 
          error!("please provide at least one param") if (params[:t_min].blank? and params[:t_max].blank?)
          
          towns = Town
          towns = towns.gte(car_travel_time_value: params[:t_min]) unless params[:t_min].blank?
          towns = towns.lte(car_travel_time_value: params[:t_max]) unless params[:t_max].blank?

          present :total_count, towns.size
          present :towns, towns, with: MyApi::Entities::Town

        end

        namespace ':town_id' do 
          before do 
            params do
              requires :town_id, type: String, desc: "id of the town"
            end
            @town = Town.find(params[:town_id]) || error!('town not found', 404)
          end

          desc "get a town infos"
          get do 
            present :town, @town, with: MyApi::Entities::Town
          end

        end

      end

    end
  end
end
