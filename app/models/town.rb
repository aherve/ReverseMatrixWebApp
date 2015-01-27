class Town
  include Mongoid::Document
  include Mongoid::Timestamps
  include Autocomplete

  has_many :lands
  has_many :projects

  field :department           , type: String
  field :codename             , type: String
  field :readable_name        , type: String
  field :lat                  , type: Float
  field :lng                  , type: Float
  field :car_travel_time_value, type: Integer
  field :car_travel_time_text , type: String

  field :distance_value       , type: Integer
  field :distance_text        , type: String

  field :population, type: Integer

  index({ car_travel_time_value: 1 }, { unique: false, name: "car_travel_time_value_index" })
  index({ codename: 1},{sparse: true, unique: true, name: 'codename_index'})

  def self.find_by_approximate_name(name)
    t   = (Town.where_autocomplete(name).first)
    t ||= (Town.where_autocomplete(name.upcase.gsub("ST",'SAINT')).first)
    t ||= (Town.where_autocomplete(name.upcase.gsub("SAINT",'ST')).first)
  end

end
