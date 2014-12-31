class Town
  include Mongoid::Document
  include Mongoid::Timestamps

  field :department
  field :codename
  field :readable_name
  field :lat
  field :lng
  field :car_travel_time_value
  field :car_travel_time_text

  field :distance_value
  field :distance_text
end
