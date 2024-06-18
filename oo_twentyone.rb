module Hand
  def hand_value
    values = hand.map {|card| card[1]}

    sum = 0
    values.each do |value|
      if value == "A"
        sum += 11
      elsif value.to_i == 0
        sum += 10
      else
        sum += value.to_i
      end
    end

    values.select { |value| value == "A"}.count.times do
      sum -= 10 if sum > 21
    end

    sum
  end

  def busted?
    total > 21
  end

  def twenty_one?
    total == 21
  end
end

class Participant
  include Hand

  attr_accessor :hand, :total, :move

  def initialize
    @hand = []
    @total = 0
    @move = nil
  end

  def hit?
    respone = nil

    loop do
      puts "Hit or Stay?:"
      respone = gets.chomp.downcase
      break if ['hit', 'stay'].include?(respone)
      puts "Sorry, must be 'hit' or 'stay'"
      puts ""
    end
    respone == 'hit'
  end

  def stay?
    !hit?
  end
end

class Player < Participant
  attr_accessor :name

  def initialize
    @name = ''
    super
  end
end

class Dealer < Participant
  include Hand

  def hit?
    answer = nil
    if hand_value < 17
      answer = 'hit'
    end
    answer == 'hit'
  end

end

class Deck
  FULL_DECK = [['A', '2'], ['A', '3'], ['A', '4'], ['A', '5'], ['A', '6'],
             ['A', '7'], ['A', '8'], ['A', '9'], ['A', '10'], ['A', 'J'],
             ['A', 'Q'], ['A', 'K'], ['A', 'A'], ['H', '2'], ['H', '3'],
             ['H', '4'], ['H', '5'], ['H', '6'], ['H', '7'], ['H', '8'],
             ['H', '9'], ['H', '10'], ['H', 'J'], ['H', 'Q'], ['H', 'K'],
             ['H', 'A'], ['S', '2'], ['S', '3'], ['S', '4'], ['S', '5'],
             ['S', '6'], ['S', '7'], ['S', '8'], ['S', '9'], ['S', '10'],
             ['S', 'J'], ['S', 'Q'], ['S', 'K'], ['S', 'A'], ['C', '2'],
             ['C', '3'], ['C', '4'], ['C', '5'], ['C', '6'], ['C', '7'],
             ['C', '8'], ['C', '9'], ['C', '10'], ['C', 'J'], ['C', 'Q'],
             ['C', 'K'], ['C', 'A']]

  attr_accessor :cards

  def initialize
    @cards = FULL_DECK
  end

end

class Card
  def initialize
    # what are the "states" of a card?
  end
end

class Game
  WINNING_TOTAL = 21
  attr_accessor :player, :dealer, :deck
  attr_reader :winning_total

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def display_welcome_message
    puts "Welcome to Twenty-One!"
    puts ""
  end

  def display_goodbye_message
    puts ""
    puts "Thanks for playing Twenty-One! Goodbye!"
  end

  def deal_card(name)
    name.hand << deck.cards.delete(deck.cards.sample)
  end

  def deal_initial_cards
    2.times do 
      deal_card(player)
      deal_card(dealer)
    end
  end

  def show_cards
    puts "You have: #{player.hand}"
    puts "Dealer has: unknown card and #{dealer.hand[1..-1]}"
    puts ""
  end

  def clear
    system "clear"
  end

  def player_turn
    puts "Your turn!"
    puts ""
    if player.hit?
      player.move = 'hit'
      puts "You chose to hit! Dealing new card..."
      puts ""
      deal_card(player)
      puts "You now have: #{player.hand}"
      puts ""
    else
      player.move = 'stay'
      puts "You chose to stay"
      puts ""
    end
  end

  def dealer_turn
    puts "Dealer's turn!"
    if dealer.hit?
      dealer.move = 'hit'
      puts "Dealer chose to hit! Dealing new card..."
      puts ""
      deal_card(dealer)
      puts "Dealer now has: unknown card and #{dealer.hand[1..-1]}"
      puts ""
    else
      dealer.move = 'stay'
      puts "Dealer chose to stay"
    end
  end

  def update_totals
    player.total = player.hand_value
    dealer.total = dealer.hand_value
  end

  def show_player_total
    puts "Your score: #{player.total}"
  end

  def show_dealer_total
    puts "Dealer score: ???"
  end

  def someone_bust?
    player.busted? || dealer.busted?
  end

  def someone_win?
    player.twenty_one? || dealer.twenty_one?
  end

  def tie?
    player.total == dealer.total
  end

  def both_stayed?
    player.move == 'stay' && dealer.move == 'stay'
  end

  def round_over?
    someone_bust? || someone_win? || both_stayed?
  end

  def show_final_totals
    puts "Your score: #{player.total}"
    puts "Dealer score: #{dealer.total}"
  end

  def show_final_cards
    puts "Final scores!"
    puts "You had: #{player.hand}"
    puts "Dealer had: #{dealer.hand}"
    puts ""
  end

  def display_game_result
    if player.busted?
      puts "Player busted! Dealer wins."
    elsif player.twenty_one? && !dealer.twenty_one?
      puts "Player hit twenty_one! Player wins."
    elsif dealer.busted?
      puts "Dealer busted! Player wins."
    elsif dealer.twenty_one? && !player.twenty_one?
      puts "Dealer hit twenty_one! Dealer wins."
    elsif player.total == dealer.total
      puts "It's a tie!" 
    elsif both_stayed?
      puts "player wins" if player.total > dealer.total
      puts "dealer wins" if dealer.total > player.total
      puts "its a tie" if dealer.total == player.total
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def reset_deck
    deck = Deck::FULL_DECK
  end

  def reset_hands
    player.hand = []
    dealer.hand = []
  end

  def reset_moves
    player.move = nil
    dealer.move = nil
  end

  def play
    loop do
      clear
      display_welcome_message
      puts "Dealing initial cards..."
      puts ""
      sleep(2)
      deal_initial_cards
      loop do
        update_totals
        show_cards
        [show_player_total, show_dealer_total]
        puts ""
        player_turn
        break if someone_bust? || someone_win?
        dealer_turn
        sleep(2)
        break if round_over?
        clear
      end
      show_final_cards
      show_final_totals
      display_game_result
      break unless play_again?
      reset_deck
      reset_hands
      reset_moves
    end

    display_goodbye_message
  end


end

Game.new.play

### WHERE TO PICK UP TMW

=begin

I was able to deal 2 cards to the player from a new deck (dup of FULL_DECK constant in Deck class). This correctly removes the cards from the new deck.

I was able to calculate and return the total value of the current hand. It doesn't save to an instance variable for the Participant class. It's just the return value of the hand_value method in the Hand module (included in Participant --> player/dealer)

Next up:

4. wrap all in a loop
5. break loop if both participants choose to "stay", get 21, or bust
6. depending on reason for breaking, display appropriate message to console
7. Figure out which level of access is appropriate for instance methods
    ex: should the player have access to methods that can modify their hand or see the dealer hand?
8. prompt player for name
9. make it look nice on the console

=end