class Town
  include Mongoid::Document
  include Mongoid::Timestamps

  field :department           , type: String
  field :codename             , type: String
  field :readable_name        , type: String
  field :lat                  , type: Float
  field :lng                  , type: Float
  field :car_travel_time_value, type: Integer
  field :car_travel_time_text , type: String

  field :distance_value       , type: Integer
  field :distance_text        , type: String

  index({ car_travel_time_value: 1 }, { unique: false, name: "car_travel_time_value_index" })
end
