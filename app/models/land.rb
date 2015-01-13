class Land
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :town

  field :price_in_euro, type: Integer
  field :surface_in_squared_meters, type: Integer
  field :description, type: String
  field :url

  field :provider
  index({ url: 1},{sparse: false, unique: true, name: 'url_land_index'})

  #denormalized data: 
  field :town_population
  field :town_department
  field :town_codename
  field :town_readable_name
  field :town_distance_value
  field :town_car_travel_time_value

  validates_uniqueness_of :url
  validates_presence_of :url

  before_save :denormalize_town_infos

  private

  def denormalize_town_infos
    unless town.blank?
      self.write_attributes(
        town_population: town.population,
        town_department: town.department,
        town_codename: town.codename,
        town_readable_name: town.readable_name,
        town_distance_value: town.distance_value,
        town_car_travel_time_value: town.car_travel_time_value,
      )
    end
  end

end
