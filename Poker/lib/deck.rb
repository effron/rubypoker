require_relative 'card'

class Deck
  attr_accessor :cards

  def initialize(cards = Card.all_cards)
    @cards = cards
  end

  def draw(n)
    cards.pop(n)
  end

  def shuffle
    cards.shuffle!
  end

  def reshuffle
    cards = Card.all_cards
    shuffle
  end

end



