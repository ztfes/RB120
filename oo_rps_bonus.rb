class Move
  VALUES = ['rock', 'paper', 'scissors', 'spock', 'lizard']

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def spock?
    @value == 'spock'
  end

  def lizard?
    @value == 'lizard'
  end

  def >(other_move)
    (rock? && other_move.scissors?) || 
      (rock? && other_move.lizard?) ||
      (paper? && other_move.rock?) || 
      (paper? && other_move.spock?) ||
      (scissors? && other_move.paper?) || 
      (scissors? && other_move.lizard?) ||
      (spock? && other_move.rock?) || 
      (spock? && other_move.scissors?) ||
      (lizard? && other_move.spock?) || 
      (lizard? && other_move.paper?)
  end

  def <(other_move)
    (rock? && other_move.spock?) || 
      (rock? && other_move.paper?) ||
      (paper? && other_move.scissors?) || 
      (paper? && other_move.lizard?) ||
      (scissors? && other_move.rock?) || 
      (scissors? && other_move.spock?) ||
      (spock? && other_move.paper?) || 
      (spock? && other_move.lizard?) ||
      (lizard? && other_move.rock?) || 
      (lizard? && other_move.scissors?)
  end  

  def to_s
    @value
  end
end

class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = 0
  end
end

class Human < Player
  def set_name
    n = ''
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Plase choose rock, paper, scissors, spock, or lizard:"
      choice = gets.chomp
      puts
      break if Move::VALUES.include? choice
      puts "sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'C3PO'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class RPSGame
  attr_accessor :human, :computer, :score, :round

  def initialize
    @human = Human.new
    @computer = Computer.new
    @round = 0
  end

  def display_welcome_message
    puts
    puts "Welcome to Rock, Paper, Scissors, Spock, Lizard (RPSSL)!"
  end

  def display_current_round
    puts
    puts "Round #{@round += 1}!"
  end

  def display_goodbye_message
    puts "Thanks for playing RPSSL. Good bye!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move} ||| #{computer.name} chose #{computer.move}"
  end

  def display_round_winner
    if human.move > computer.move
      puts "#{human.name} won this round!"
      human.score += 1
    elsif human.move < computer.move
      puts "#{computer.name} won this round!"
      computer.score += 1
    else
      puts "This round is a tie!"
    end
  end  

   def display_score
    puts
    puts "current score: #{human.name} - #{human.score} | #{computer.name} - #{computer.score}}"
  end 

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, must be y or n."
    end

    return false if answer.downcase == 'n'
    return true if answer.downcase == 'y'
  end

  def reset_game
    @round = 0
    human.score = 0
    computer.score = 0
  end

  def play
    display_welcome_message
    loop do
      display_current_round
      human.choose
      computer.choose
      display_moves
      display_round_winner
      display_score
      if human.score == 10
        puts "#{human.name} won the match!"
        reset_game
        break unless play_again?
      elsif computer.score == 10
        puts "#{computer.name} won the match!"
        reset_game
        break unless play_again?
      end
    end
    display_goodbye_message
  end
end

RPSGame.new.play
