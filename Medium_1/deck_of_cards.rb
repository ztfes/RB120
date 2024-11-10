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

deck = Deck.new

drawn = []
p 52.times { drawn << deck.draw }
p drawn.count { |card| card.rank == 5 } == 4
p drawn.count { |card| card.suit == 'Hearts' } == 13

drawn2 = []
52.times { drawn2 << deck.draw }
p drawn != drawn2 # Almost always.
