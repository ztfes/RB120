class Person
  attr_reader :name
  attr_accessor :location

  def initialize(name)
    @name = name
  end

  def teleport_to(latitude, longitude)
    @location = GeoLocation.new(latitude, longitude)
  end

  def coordinates
    [location.latitude, location.longitude]
  end
end

class GeoLocation
  attr_reader :latitude, :longitude

  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
  end

  def to_s
    "(#{latitude}, #{longitude})"
  end
end

# Example

ada = Person.new('Ada')
ada.location = GeoLocation.new(53.477, -2.236)

grace = Person.new('Grace')
grace.location = GeoLocation.new(-33.89, 151.277)

ada.teleport_to(-33.89, 151.277)

p ada.location                   # (-33.89, 151.277)
p grace.location                 # (-33.89, 151.277)
p ada.coordinates
p grace.coordinates
puts ada.coordinates == grace.coordinates # expected: true
                                 # actual: false 
                                 # comparing two OBJECTS, not lat/long