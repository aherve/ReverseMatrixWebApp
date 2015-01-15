describe MyApi::V1::Land do 

  before do 
    Mongoid.purge!
    @land = FactoryGirl.create(:land)
  end

  #{{{ get
  describe :get do 
    subject(:get_land) { get "api/lands/#{@land.id}"}

    it "finds land" do 
      get_land
      assert json_response.has_key?("land")
      expect(json_response["land"]["id"]).to eq @land.id.to_s
    end

  end
  #}}}

  #{{{ archive/unarchive
  describe :archive do 
    subject(:archive){ post "/api/lands/#{@land.id}/archive!" ; @land.reload }
    subject(:unarchive){ post "/api/lands/#{@land.id}/unarchive!" ; @land.reload}

    it 'archive does archive a land' do 
      expect{archive}.to change{Land.last.archived}.from(false).to(true)
    end

    it 'unarchive unarchives a land' do 
      @land.update_attribute(:archived, true)
      expect{unarchive}.to change{Land.last.archived}.from(true).to(false)
    end

  end
  #}}}

end
