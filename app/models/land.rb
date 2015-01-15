class Land
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :town

  field :price_in_euro, type: Integer
  field :surface_in_squared_meters, type: Integer
  field :description, type: String
  field :url
  field :provider
  field :archived, type: Boolean, default: false
  field :interesting, type: Boolean, default: false
  field :active_url, type: Boolean, default: true

  #denormalized data: 
  field :town_population
  field :town_department
  field :town_codename
  field :town_readable_name
  field :town_distance_value
  field :town_car_travel_time_value
  field :town_car_travel_time_text

  index({ url: 1},{sparse: false, unique: true, name: 'url_land_index'})

  validates_uniqueness_of :url
  validates_presence_of :url

  before_save :denormalize_town_infos
  after_create :new_land_mail

  def interesting!
    self.update_attributes(interesting: true)
    LandMailer.new_interesting_land(self).deliver
  end

  def not_interesting!
    self.update_attributes(interesting: false)
  end

  def archive!
    self.update_attributes(archived: true)
  end

  def unarchive!
    self.update_attributes(archived: false)
  end

  private

  def new_land_mail
    LandMailer.new_land(self).deliver
  end

  def denormalize_town_infos
    t = town
    unless t.blank?
      self.write_attributes(
        town_population: t.population,
        town_department: t.department,
        town_codename: t.codename,
        town_readable_name: t.readable_name,
        town_distance_value: t.distance_value,
        town_car_travel_time_value: t.car_travel_time_value,
        town_car_travel_time_text: t.car_travel_time_text,
      )
    end
  end

end
