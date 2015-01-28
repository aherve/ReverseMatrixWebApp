FactoryGirl.define do
  factory :project do
    town_id {BSON::ObjectId.new}
    name "MyFancyProject"
    min_surface 1000
    max_surface 2000
    max_distance 2
  end

end
