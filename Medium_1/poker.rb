class Card
  include Comparable
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  SUITS        = %w(Spades Hearts Diamonds Clubs).freeze
  RANKS        = [2, 3, 4, 5, 6, 7, 8, 9, 10, "Jack", "Queen", "King", "Ace"].freeze
  RANKS_SCORES = RANKS.each_with_index.to_h

  def to_s
    "#{@rank} of #{@suit}"
  end

  def <=>(other)
    RANKS_SCORES[rank] <=> RANKS_SCORES[other.rank]
  end
end

class Deck < Card
  attr_accessor :cards

  def initialize
    @cards = Card::RANKS.flat_map do |rank|
      Card::SUITS.map do |suit|
        Card.new(rank,suit)
      end
    end
  end

  def reshuffle
    @cards = Card::RANKS.flat_map do |rank|
      Card::SUITS.map do |suit|
        Card.new(rank,suit)
      end
    end
  end

  def draw
    if @cards.empty?
      reshuffle
      @cards.shuffle.pop
    else
      @cards.shuffle.pop
    end
  end
end

class PokerHand < Deck
  attr_accessor :hand
  def initialize(deck)
    new_deck = deck
    starting_hand = Array.new(5)
    @hand = starting_hand.map { new_deck.draw}
  end

  def print
    puts hand.each {|card| card.to_s}
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  private

  # Straight flush: Five cards of the same suit in sequence (if those five are A, K, Q, J, 10; it is a Royal Flush)

  def royal_flush?
    hand.group_by {|card| card.rank}.keys.sort_by {|value| RANKS.index(value)} == [10, 'Jack', 'Queen', 'King', 'Ace'] &&
                                                                                                             straight? && 
                                                                                                             flush?
  end

  def straight_flush?
    straight? && flush?
  end

  def four_of_a_kind?
    hand.group_by {|card| card.rank}.values.count {|element| element.count == 4} == 1
  end

  def full_house?
    three_of_a_kind? && pair?
  end

  def flush?
    hand.group_by {|card| card.suit}.values.count {|element| element.count == 5} == 1
  end

  def straight?
    possible_straights = []
    (0..(RANKS.size - 5)).to_a.each_with_index do |i, _|
      possible_straights << RANKS[i..i+4]
    end
    sorted = hand.group_by {|card| card.rank}.keys.sort_by {|value| RANKS.index(value)}
    possible_straights.include?(sorted)
  end

  def three_of_a_kind?
    hand.group_by {|card| card.rank}.values.count {|element| element.count == 3} == 1
  end

  def two_pair?
    hand.group_by {|card| card.rank}.values.count {|element| element.count == 2} == 2
  end

  def pair?
    hand.group_by {|card| card.rank}.values.count {|element| element.count == 2} == 1
  end
end

hand = PokerHand.new(Deck.new)
hand.print
puts hand.evaluate

# Danger danger danger: monkey
# patching for testing purposes.
class Array
  alias_method :draw, :pop
end

# Test that we can identify each PokerHand type.
hand = PokerHand.new([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])
puts hand.evaluate == 'Royal flush'

hand = PokerHand.new([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight flush'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Four of a kind'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Full house'

hand = PokerHand.new([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])
puts hand.evaluate == 'Flush'

hand = PokerHand.new([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new('Queen', 'Clubs'),
  Card.new('King',  'Diamonds'),
  Card.new(10,      'Clubs'),
  Card.new('Ace',   'Hearts'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts hand.evaluate == 'Three of a kind'

hand = PokerHand.new([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Two pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Pair'

hand = PokerHand.new([
  Card.new(2,      'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new(5,      'Diamonds'),
  Card.new(9,      'Spades'),
  Card.new(3,      'Diamonds')
])
puts hand.evaluate == 'High card'


