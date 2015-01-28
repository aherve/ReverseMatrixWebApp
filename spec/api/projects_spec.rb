describe MyApi::V1::Projects do 
  before do 
    Mongoid.purge!
  end

  #{{{ create
  describe :create do 
    before do 
      @town = FactoryGirl.create(:town)
    end
    subject(:create_project){ post '/api/projects/', FactoryGirl.build(:project).attributes.merge(town_id: @town.id)}

    context "when logged out" do

      it "requires login" do 
        create_project
        expect(response.status).to eq 401
      end

    end

    context "when logged in" do 
      before {sign_up_and_login!}

      it "creates project" do 
        expect{create_project}.to change{Project.count}.by(1)
      end

      it "associates project to its owner" do 
        create_project
        expect(Project.last.owner).to eq @user
      end

      it "returns the project" do 
        create_project
        expect(parsed_response["project"]["id"]).to eq(Project.last.id.to_s)
      end

    end
  end
  #}}}

  #{{{
  describe :'get/index/update/delete' do 
    before do
      sign_up_and_login!
      @project = FactoryGirl.create(:project)
      @project.town = FactoryGirl.create(:town)
      @project.owner = @user ; @project.save
    end

    subject(:update_project){put "/api/projects/#{@project.id}", name: "hahahoho"}
    subject(:delete_project){delete "/api/projects/#{@project.id}"}
    subject(:get_project){get "/api/projects/#{@project.id}"}
    subject(:index_project){get "/api/projects"}

    context "when I own the project" do 
      before do 
        @project.update_attribute(:owner_id, @user.id)
      end

      it "update updates a project" do
        expect{update_project}.to change{Project.last.name}.to("hahahoho")
      end

      it "GET finds a project" do 
        get_project
        expect(parsed_response["project"]["id"]).to eq @project.id.to_s
      end

      it "DELETE deletes a projet" do
        expect{delete_project}.to change{Project.count}.by(-1)
      end

      it "index liss my projects" do 
        index_project
        expect(parsed_response["projects"].size).to eq 1
        expect(parsed_response["projects"].first["id"]).to eq @project.id.to_s
      end

    end

    context "when I don't own the project" do 
      before do 
        @project.update_attribute(:owner_id, nil)
      end
      it "updates 404" do 
        update_project
        expect(response.status).to eq 404
      end

      it "get 404" do 
        get_project
        expect(response.status).to eq 404
      end

      it 'delete 404' do 
        delete_project
        expect(response.status).to eq 404
      end

      it "index don't find the project" do 
        index_project
        assert(parsed_response["projects"].empty?)
      end

    end

  end
  #}}}

  #{{{ score
  describe :score do 
    before do 
      sign_up_and_login!
      @project = FactoryGirl.create(:project)
      @project.town = FactoryGirl.create(:town)
      @project.owner = @user ; @project.save
      @land = FactoryGirl.create(:land)
    end

    subject(:favorite) { post "/api/projects/#{@project.id}/lands/#{@land.id}/score", score: 1 }
    subject(:unselect) { post "/api/projects/#{@project.id}/lands/#{@land.id}/score", score: 0 }
    subject(:archive)  { post "/api/projects/#{@project.id}/lands/#{@land.id}/score", score: -1 }

    it "archive land" do 
    pending
      expect{archive}.to change{Project.last.archived_land_ids}.from([]).to([@land.id])
    end

    it "favorite land" do 
    pending
      expect{favorite}.to change{Project.last.favorite_land_ids}.from([]).to([@land.id])
    end

    it "unselect land" do 
    pending
      favorite
      expect{unselect}.to change{Project.last.favorite_land_ids}.from([@land.id]).to([])
    end
  end
  #}}}

end
