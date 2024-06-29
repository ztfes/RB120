class CircularBuffer
  attr_accessor :buffer

  def initialize(buffer_size)
    keys = []
    buffer_size.times do |index|
      keys << "P#{index+1}".to_sym
    end
    @buffer = Hash.new
    keys.each {|key| @buffer[key] = ''}
  end

  def empty?
    @buffer.values.all? {|vals| vals == ''}
  end

  def open_position?
    @buffer.values.any? {|vals| vals == ''}
  end

  def full_buffer?
    !open_position?
  end

  def clear_position(key)
    @buffer[key] = ''
  end

  def put(obj)
    #add obj to hash at earliest available key OR remove oldest key (lowest num) and add obj to that key
    if !full_buffer?
      key = @buffer.key('')
      @buffer[key] = obj
    else
      get
      key = @buffer.key('')
      @buffer[key] = obj
    end     
  end

  def get
    #remove and return oldest value
    if !empty?
      oldest_item = @buffer.values.delete_if {|val| val == ''}.min
      clear_position(@buffer.key(oldest_item))
      oldest_item
    else
      nil
    end
  end

end

buffer = CircularBuffer.new(3)
puts buffer.get == nil

buffer.put(1)
p buffer
buffer.put(2)
p buffer
puts buffer.get == 1

buffer.put(3)
buffer.put(4)
puts buffer.get == 2

buffer.put(5)
buffer.put(6)
buffer.put(7)
puts buffer.get == 5
puts buffer.get == 6
puts buffer.get == 7
puts buffer.get == nil

buffer = CircularBuffer.new(4)
puts buffer.get == nil

buffer.put(1)
buffer.put(2)
puts buffer.get == 1

buffer.put(3)
buffer.put(4)
puts buffer.get == 2

buffer.put(5)
buffer.put(6)
buffer.put(7)
puts buffer.get == 4
puts buffer.get == 5
puts buffer.get == 6
puts buffer.get == 7
puts buffer.get == nil

=begin

Much better example:

class CircularBuffer
  def initialize(size)
    @size = size
    @buffer = Array.new
  end

  def put(object)
    if buffer_full?
      buffer.pop
      buffer.unshift(object)
    else
      buffer.unshift(object)
    end
  end

  def buffer_full?
    buffer.size == size
  end

  def get
    buffer.pop
  end

  private 

  attr_reader :size, :buffer
end

=end