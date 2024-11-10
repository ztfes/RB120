class GuessingGame
  include Comparable

  public

  def initialize(lower=1, upper=100)
    @range = (lower..upper).to_a
    @number_of_guesses = Math.log2(@range.size).to_i + 1
    @answer = @range.sample
    @guess = nil
  end

  def play
    loop do
      opening_statement
      player_guess
      puts "Your guess is too high\n" if guess_is_too_high?
      puts "Your guess is too low\n" if guess_is_too_low?
      if correct_guess?
        puts "That's the number!"
        puts "You won!"
        break
      end

      if number_of_guesses == 0
        puts "\nYou have no more guesses. You lost!\n"
        break
      end
    end
  end

  private

  attr_reader :range, :answer
  attr_accessor :guess, :number_of_guesses

  def opening_statement
    print("\nYou have #{number_of_guesses} #{guess_message} remaining.")
    puts ""
  end

  def guess_message
    if number_of_guesses == 1
      "guess"
    else
      "guesses"
    end
  end


  def guess_is_too_high?
    guess > answer
  end

  def guess_is_too_low?
    guess < answer
  end

  def correct_guess?
    guess == answer
  end

  def player_guess
    input = nil
    loop do
      print("Enter an integer between #{range.min} and #{range.max}: ")
      input = gets.chomp.to_i
      break if range.include?(input)
      print("Invalid guess.")
    end
    @number_of_guesses -= 1
    @guess = input
  end
end

game = GuessingGame.new(1, 1200)
game.play