module MyApi
  module V1
    class Lands < Grape::API
      format :json

      namespace :lands do 

        #{{{ index (search)
        desc "Search for lands"
        params do 
        end
        get do
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

          #{{{ archive/unarchive
          [:archive!, :unarchive!].each do |method|
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
