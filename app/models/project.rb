class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :owner, class_name: "User", inverse_of: :projects
  belongs_to :town

  has_and_belongs_to_many :archived_lands, class_name: "Land", inverse_of: :archived_in
  has_and_belongs_to_many :favorite_lands, class_name: "Land", inverse_of: :favorite_in

  field :name
  field :min_surface
  field :max_surface
  field :max_distance

  validates_presence_of :name, :max_distance, :min_surface, :max_surface

  def archive!(land)
    archived_lands << land
    favorite_lands.delete(land)
    save
  end

  def favorite!(land)
    favorite_lands << land
    archived_lands.delete(land)
    save
  end

  def unselect!(land)
    favorite_lands.delete(land)
    archived_lands.delete(land)
    save
  end

  def lands
    Land
    .gte(surface_in_squared_meters: min_surface)
    .lte(surface_in_squared_meters: max_surface)
    .near_sphere(location: town.location)
    .max_distance(location: max_distance*1e-7)
  end

  def land_ids
    lands.only(:id).map(&:id)
  end

  def new_lands
    Land.any_in(id: ( land_ids - favorite_land_ids - archived_land_ids) )
  end

end
