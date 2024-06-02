class Shelter
  attr_accessor :owner_pet_list

  def initialize
    @@owner_pet_list = Hash.new {|hsh, key| hsh[key] = []}
  end

  def adopt(owner, pet)
    @@owner_pet_list[owner].push pet
  end

  def print_adoptions
    @@owner_pet_list.each do |owner_name, list_of_owners_pets|
      puts "#{owner_name.name} has adopted the following pets"
      list_of_owners_pets.each do |pet|
        puts "a #{pet.pet_type} named #{pet.name}"
      end
    end
  end

end

class Pet
  attr_reader :name, :pet_type
  def initialize(animal, n)
    @pet_type = animal
    @name = n
  end
end

class Owner < Shelter
  attr_reader :name, :owner_pet_list

  def initialize(full_name)
    @name = full_name
  end

  def number_of_pets
    @@owner_pet_list[self].size
  end

end

butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter = Shelter.new
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)
shelter.print_adoptions
puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
