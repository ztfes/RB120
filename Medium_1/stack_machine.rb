class Minilang < StandardError
  attr_accessor :commands, :stack, :register

  def initialize(commands)
    @commands = commands
    @stack = [0]
    @register = 0
  end

  def n(num)
    register = num.to_i
  end

  def push
    stack.push(register)
  end

  def pop
    register = stack.pop
  end

  def add
    register += stack.pop
  end

  def sub
    register -= stack.pop
  end

  def mult
    register *= stack.pop
  end

  def div
    register /= stack.pop
  end

  def mod
    register %= stack.pop
  end

  def print
    puts register
  end

  def eval
    commands.split.each do |token|
      #puts token.to_i
      case token
      when 'ADD'   then add
      when 'DIV'   then div
      when 'MULT'  then mult
      when 'MOD'   then mod
      when 'SUB'   then sub
      when 'PUSH'  then push
      when 'POP'   then pop
      when 'PRINT' then print
      else              n(token)
      end
    end
  end
end

# Minilang.new('PRINT').eval
# # 0

Minilang.new('5 PUSH PRINT').eval
# 5


# Minilang.new('5 PUSH 3 MULT PRINT').eval
# # 15

# Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# # 5
# # 3
# # 8

# Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# # 10
# # 5

# Minilang.new('5 PUSH POP POP PRINT').eval
# # Empty stack!

# Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# # 6

# Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# # 12

# Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# # Invalid token: XSUB

# Minilang.new('-3 PUSH 5 SUB PRINT').eval
# # 8

# Minilang.new('6 PUSH').eval
# # (nothing printed; no PRINT commands)