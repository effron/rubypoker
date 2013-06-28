# encoding: utf-8

require 'rspec'
require 'card'

describe Card do
  let(:ace_of_spades) { Card.new(:spades, :ace) }
  let(:two_of_hearts) { Card.new(:hearts, :deuce) }
  let(:other_two_of_hearts) { Card.new(:hearts, :deuce) }
  let(:two_of_clubs) { Card.new(:clubs, :deuce) }
  let(:king_of_clubs) { Card.new(:clubs, :king) }
  describe "#value" do

    it "value of ace is ace" do
      expect(ace_of_spades.value).to eq(:ace)
    end


    it "value of two is two" do
      expect(two_of_hearts.value).to eq(:deuce)
    end
  end

  describe "#suit" do
    it "suit of hearts is hearts" do
      expect(two_of_hearts.suit).to eq(:hearts)
    end

    it "suit of spades is spades" do
      expect(ace_of_spades.suit).to eq(:spades)
    end
  end

  describe "#==" do
    it "two_of_hearts is equal to another two_of_hearts" do
      expect(two_of_hearts == other_two_of_hearts).to be_true
    end

    it "two_of_hearts is equal to two_of_clubs" do
      expect(two_of_hearts == two_of_clubs).to be_true
    end
  end

  describe "#<=>" do
    it "compares the value of two cards" do
      expect(king_of_clubs > two_of_clubs).to be_true
    end
    it "compares value of cards of different suits" do
      expect(two_of_hearts < ace_of_spades).to be_true
    end
  end

  describe "#.to_s" do
    it "converts suit and value to printable thing" do
      expect(two_of_hearts.to_s).to eq("2♥")
    end
  end

  describe "::all_cards" do
    let (:cards) { Card.all_cards }
    let (:rand_suit) { Card::SUITS.keys.sample }
    let (:rand_value) { Card::VALUES.keys.sample }
    let (:rand_card) { Card.new(rand_suit, rand_value) }

    it "returns an array with all 52 cards" do
      expect(Card.all_cards.uniq.length).to eq(52)
    end

    it "contains any random card" do
      expect(cards.include?(rand_card)).to be_true
    end
  end

end



