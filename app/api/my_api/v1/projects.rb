module MyApi
  module V1
    class Projects < Grape::API
      format :json

      namespace :projects do 
        before do 
          sign_in!
        end

        #{{{ index
        desc "get a concise list of my projects"
        get do 
          present :projects, current_user.projects, with: MyApi::Entities::Project
        end
        #}}}

        #{{{ create
        desc "create a project"
        params do 
          requires :town_id, type: String, desc: "the town id this project is associated with"
          requires :name, type: String, desc: "project's name"
          requires :min_surface, type: Integer, desc: "min surface in squared meters"
          requires :max_surface, type: Integer, desc: "min surface in squared meters"
          requires :max_distance, type: Integer, desc: "max distance from town in meters"
        end
        post do 
          clean_params = ActionController::Parameters.new(params).permit([
            :town_id,
            :name,
            :min_surface,
            :max_surface,
            :max_distance,
          ])

          p =Project.new(clean_params.merge(owner: current_user)) 

          if p.save
            present :project, p, with: MyApi::Entities::Project
          else
            error!(p.errors)
          end
        end
        #}}}

        namespace ':project_id' do 
          before do 
            params do
              requires :project_id, desc: "id of the project"
            end
            @project = Project.find_by(id: params[:project_id], owner_id: current_user.id) || error!("project not found",404)
          end


          #{{{ get
          desc "get the full description of the project"
          get do 
            present :project, @project, with: MyApi::Entities::Project
          end
          #}}}

          #{{{ update
          desc "update a project settings"
          params do 
            optional :town_id, type: String, desc: "the town id this project is associated with"
            optional :name, type: String, desc: "project's name"
            optional :min_surface, type: Integer, desc: "min surface in squared meters"
            optional :max_surface, type: Integer, desc: "min surface in squared meters"
            optional :max_distance, type: Integer, desc: "max distance from town in meters"
          end
          put do 
            clean_params = ActionController::Parameters.new(params).permit([
              :town_id,
              :name,
              :min_surface,
              :max_surface,
              :max_distance,
            ])

            if @project.update_attributes(clean_params)
              present :project, @project, with: MyApi::Entities::Project
            else
              error!(@project.errors)
            end
          end
          #}}}

          #{{{ destroy
          desc "delete a project"
          delete do 
            @project.destroy
            present :status, :destroyed
          end
          #}}}

          namespace :lands do 

            #{{{ archived
            desc "get the archived lands for this project"
            get :archived do 
              present :archived_lands, @project.archived_lands, with: MyApi::Entities::Land
            end
            #}}}

            #{{{ new
            desc "get the new lands for this project"
            get :new do 
              present :new_lands, @project.new_lands, with: MyApi::Entities::Land
            end
            #}}}

            #{{{ favorite
            desc "get the favorite lands for this project" 
            get :favorite do 
              present :favorite_lands, @project.favorite_lands, with: MyApi::Entities::Land
            end
            #}}}

            namespace ':land_id' do 
              before do 
                params do
                  requires :land_id, desc: "id of the land"
                end
                @land = @project.lands.find_by(id: params[:land_id]) || error!("land not found",404)
              end

              #{{{ score
              desc "archive, favorite, or unselect land."
              params do 
                requires :score, type: Integer, desc: "1=> favorite, -1 => archive, 0=> unselect"
              end
              post :score do 
                if (s = params["score"]) == 1
                  @project.favorite!(@land)
                elsif s == 0
                  @project.unselect!(@land)
                elsif s == -1
                  @project.archive!(@land)
                else
                  error!("wrong argument score", '403')
                end

                present :project, @project, with: MyApi::Entities::Project
              end
              #}}}

            end
          end
        end
      end
    end
  end
end
