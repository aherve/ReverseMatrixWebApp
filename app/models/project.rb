class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :owner, class_name: "User", inverse_of: :projects
  belongs_to :town
  
  has_and_belongs_to_many :new_lands, class_name: "Land", inverse_of: :new_in
  has_and_belongs_to_many :archived_lands, class_name: "Land", inverse_of: :archived_in
  has_and_belongs_to_many :favorite_lands, class_name: "Land", inverse_of: :favorite_in

  field :name
  field :min_surface
  field :max_surface
  field :min_distance
  field :max_distance

end
