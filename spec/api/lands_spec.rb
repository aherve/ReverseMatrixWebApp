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
      assert parsed_response.has_key?("land")
      expect(parsed_response["land"]["id"]).to eq @land.id.to_s
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

  #{{{ interesting/not interesting
  describe :interesting do 
    subject(:interesting){ post "/api/lands/#{@land.id}/interesting!" ; @land.reload }
    subject(:not_interesting){ post "/api/lands/#{@land.id}/not_interesting!" ; @land.reload}

    it 'interesting does interesting a land' do 
      expect{interesting}.to change{Land.last.interesting}.from(false).to(true)
    end

    it 'uninteresting uninterestings a land' do 
      @land.update_attribute(:interesting, true)
      expect{not_interesting}.to change{Land.last.interesting}.from(true).to(false)
    end

  end
  #}}}

end
