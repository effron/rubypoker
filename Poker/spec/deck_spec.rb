require 'rspec'
require 'deck'

describe Deck do
  let (:deck) { Deck.new }

  describe "#initialize" do
    it "Defaults to contain all cards" do
      expect(deck.cards.size).to eq(52)
    end
  end

  describe "#draw" do
    it "lets you draw a card" do
      expect(deck.draw(1)).to eq([Deck.new.cards.last])
    end

    it "shrinks after a card is drawn" do
      deck.draw(1)
      expect(deck.cards.size).to eq(51)
    end

    it "lets you draw multiple cards" do
      expect(deck.draw(4)).to eq(Deck.new.cards[-4..-1])
    end
  end

  describe "#shuffle" do
    it "changes card order" do
      deck.shuffle
      deck.cards.should_not eq(Deck.new.cards)
    end
  end

  describe "#reshuffle" do
    before(:each) { deck.reshuffle }

    it "builds new deck" do
      expect(deck.cards.length).to eq(Deck.new.cards.length)
    end

    it "shuffles cards" do
      deck.cards.should_not eq(Deck.new.cards)
    end
  end

end