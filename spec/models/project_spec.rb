require 'rails_helper'

RSpec.describe Project, :type => :model do

  it "validates factory" do 
    expect(FactoryGirl.build(:project).valid?).to eq true
  end
end
