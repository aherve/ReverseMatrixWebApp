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
          requires :min_distance, type: Integer, desc: "min distance from town in meters"
          requires :max_distance, type: Integer, desc: "max distance from town in meters"
        end
        post do 
          clean_params = ActionController::Parameters.new(params).permit([
            :town_id,
            :name,
            :min_surface,
            :max_surface,
            :min_distance,
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
            optional :min_distance, type: Integer, desc: "min distance from town in meters"
            optional :max_distance, type: Integer, desc: "max distance from town in meters"
          end
          put do 
            clean_params = ActionController::Parameters.new(params).permit([
              :town_id,
              :name,
              :min_surface,
              :max_surface,
              :min_distance,
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


        end
      end
    end
  end
end
