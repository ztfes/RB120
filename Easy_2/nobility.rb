module Walk
  def walk
    "#{self} #{gait} forward"
  end
end

class Person
  include Walk
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    name
  end

  private

  def gait
    "strolls"
  end
end

class Noble < Person
  include Walk
  attr_reader :name, :title

  def initialize(name, title)
    super(name)
    @title = title
  end

  def to_s
    "#{title} #{name}"
  end

  private

  def gait
    "struts"
  end
end

class Cat
  include Walk
  attr_reader :name

  def initialize(name)
    @name = name
  end
  
  def to_s
    name
  end

  private

  def gait
    "saunters"
  end
end

class Cheetah
  include Walk
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    name
  end

  private

  def gait
    "runs"
  end
end

byron = Noble.new("Byron", "Lord")
puts byron.walk
# => "Lord Byron struts forward"
#puts byron.name
#puts byron.title

mike = Person.new("Mike")
puts mike.walk
# => "Mike strolls forward"
#puts mike.name

kitty = Cat.new("Kitty")
puts kitty.walk
# => "Kitty saunters forward"
#puts kitty.name

flash = Cheetah.new("Flash")
puts flash.walk
# => "Flash runs forward"
#puts flash.name