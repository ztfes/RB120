class Minilang < StandardError
  attr_accessor :commands, :stack, :register

  VALID_COMMANDS = ['PUSH', 'ADD', 'SUB', 'MULT', 'DIV', 'MOD', 'POP', 'PRINT']

  def initialize(commands)
    @commands = commands
    @stack = [0]
    @register = 0
  end

  def n(num)
    @register = num.to_i if num =~ /\A[-+]?\d+\z/
  end

  def push
    stack.push(@register)
  end

  def pop
    @register = stack.pop
  end

  def add
    @register += stack.pop
  end

  def sub
    @register -= stack.pop
  end

  def mult
    @register *= stack.pop
  end

  def div
    @register /= stack.pop
  end

  def mod
    @register %= stack.pop
  end

  def print
    if @stack.empty?
      puts "Empty stack!"
    else
      puts @register
    end
  end

  def valid?(command)
    VALID_COMMANDS.include?(command) || register_value?(command)
  end

  def invalid?(command)
    !valid?(command)
  end

  def invalid_command(command)
    puts "Invalid token: #{command}" if !valid?(command)
  end

  def register_value?(command)
    command == command.to_i.to_s
  end

  def eval
    commands.split.each do |token|
      invalid_command(token) if invalid?(token)
      break if invalid?(token)

      case token
      when 'ADD'                  then add
      when 'DIV'                  then div
      when 'MULT'                 then mult
      when 'MOD'                  then mod
      when 'SUB'                  then sub
      when 'PUSH'                 then push
      when 'POP'                  then pop
      when 'PRINT'                then print
      else                        n(token)
      end
    end
  end
end

Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH PRINT').eval
# 5

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# 10
# 5

Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)