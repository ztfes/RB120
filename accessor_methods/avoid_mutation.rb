class Person
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def name
    @name.dup
  end

  # def name
  #   "#{@name}"
  # end

  # def name
  #   "#{@name}"
  # end

end

person1 = Person.new('James')
puts person1.name.reverse!
puts person1.name