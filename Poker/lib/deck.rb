require_relative 'card'

class Deck
  attr_accessor :cards

  def initialize(cards = Card.all_cards)
    @cards = cards
  end

  def draw(n)
    raise DeckError.new, "Not enough cards in deck" if @cards.size < n
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

class DeckError < StandardError
end


