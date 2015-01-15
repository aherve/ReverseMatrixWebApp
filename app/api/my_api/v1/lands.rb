module MyApi
  module V1
    class Lands < Grape::API
      format :json

      namespace :lands do 

        #{{{ index (search)
        desc "Search for lands"
        params do 
          optional :min_traject, type: Integer, desc: "minimum traject time from paris in seconds"
          optional :max_traject, type: Integer, desc: "max traject time from paris in second"
          optional :min_surface, type: Integer, desc: "min surface in squared meter"
          optional :max_surface, type: Integer, desc: "max surface in squared meter"
          optional :include_archived, type: Integer, desc: "-1 to ignore archived, 0 to include everything, 1 to ONLY include archived. default = -1", default: -1
          optional :include_inactive, type: Integer, desc: "-1 to ignore inactive, 0 to include everything, 1 to ONLY include inactive. default = -1", default: -1
        end
        get do

          lands = Land.all

          # active_url
          if params[:include_inactive] == 1
            lands = lands.where(active_url: false)
          elsif params[:include_inactive] == -1
            lands = lands.where(active_url: true)
          end

          # archived
          if params[:include_archived] == 1
            lands = lands.where(archived: true)
          elsif params[:include_archived] == -1
            lands = lands.where(archived: false)
          end

          unless params[:min_surface].blank?
            lands = lands.gte(surface_in_squared_meters: params[:min_surface])
          end

          unless params[:max_surface].blank?
            lands = lands.lte(surface_in_squared_meters: params[:max_surface])
          end

          unless params[:max_traject].blank?
            lands = lands.lte(town_car_travel_time_value: params[:max_traject])
          end

          unless params[:min_traject].blank?
            lands = lands.gte(town_car_travel_time_value: params[:min_traject])
          end

          present :total, lands.count
          present :lands, lands, with: MyApi::Entities::Land

        end
        #}}}

        #{{{ interesting
        desc "list all lands of interest"
        get :interesting do 
          present :lands, Land.where(interesting: true), with: MyApi::Entities::Land
        end
        #}}}

        namespace ':land_id' do
          before do 
            params do 
              requires :land_id, type: String, desc: "land id"
            end
            @land = Land.find(params[:land_id]) || error!("not found",404)
          end

          #{{{ get
          desc "get a land details"
          get do 
            present :land, @land, with: MyApi::Entities::Land
          end
          #}}}

          #{{{ archive/unarchive/interesting/not_intersting
          [:interesting!, :not_interesting!, :archive!, :unarchive!].each do |method|
            desc "#{method} land"
            post method do 
              if @land.send(method)
                present :land, @land, with: MyApi::Entities::Land 
              else
                error!(@land.errors.messages)
              end
            end
          end
          #}}}

        end


      end
    end
  end
end
