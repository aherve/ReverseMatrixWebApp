class TownImport
  def initialize(data)
    @data = JSON.parse(data.chomp)
  end

  def proper_hash
    {
      department: @data["department"],
      codename: @data["codename"],
      readable_name: @data["readable_name"],
      lat: @data["lat"].to_f,
      lng: @data["lng"].to_f,
      car_travel_time_value: @data["car_duration"]["value"].to_i,
      car_travel_time_text: @data["car_duration"]["text"],
      distance_value: @data["distance"]["value"].to_i,
      distance_text: @data["distance"]["text"],
    }
  end

  def town_import!
    puts Town.create(proper_hash)
  end

  def self.town_import(line)
    ti = TownImport.new(line)
    ti.town_import!
  end

end

ARGF.each do |line|
  next if line.chomp.blank?
  TownImport.town_import(line) rescue nil
end
