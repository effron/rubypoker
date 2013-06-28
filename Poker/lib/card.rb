# encoding: utf-8

class Card
  include Comparable

  POKER_VALUES = {
    deuce: 2,
    three: 3,
    four: 4,
    five: 5,
    six: 6,
    seven: 7,
    eight: 8,
    nine: 9,
    ten: 10,
    jack: 11,
    queen: 12,
    king: 13,
    ace: 14,
  }

  SUITS = {
    spades: "♠",
    clubs: "♣",
    hearts: "♥",
    diamonds: "♦",
  }

  VALUES = {
    deuce: "2",
    three: "3",
    four: "4",
    five: "5",
    six: "6",
    seven: "7",
    eight: "8",
    nine: "9",
    ten: "T",
    jack: "J",
    queen: "Q",
    king: "K",
    ace: "A"
  }

  def self.all_cards
    cards = []
    SUITS.keys.each do |suit|
      VALUES.keys.each do |value|
        cards << Card.new(suit, value)
      end
    end

    cards
  end

  attr_reader :suit, :value
  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def <=>(other_card)
    POKER_VALUES[value] <=> POKER_VALUES[other_card.value]
  end

  def to_s
    VALUES[value]+SUITS[suit]
  end

end