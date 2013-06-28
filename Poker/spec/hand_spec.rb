require 'rspec'
require 'hand'

describe Hand do
  let(:s_2) { Card.new(:spades, :deuce) }
  let(:s_3) { Card.new(:spades, :three) }
  let(:c_3) { Card.new(:clubs, :three) }
  let(:s_4) { Card.new(:spades, :four)}
  let(:h_4) { Card.new(:hearts, :four) }
  let(:s_5) { Card.new(:spades, :five) }
  let(:d_8) { Card.new(:diamonds, :eight)}
  let(:s_9) { Card.new(:spades, :nine) }
  let(:d_9) { Card.new(:diamonds, :nine) }
  let(:c_9) { Card.new(:clubs, :nine) }
  let(:h_9) { Card.new(:hearts, :nine) }
  let(:d_T) { Card.new(:diamonds, :ten) }
  let(:s_T) { Card.new(:spades, :ten) }
  let(:s_J) { Card.new(:spades, :jack) }
  let(:d_J) { Card.new(:diamonds, :jack) }
  let(:d_Q) { Card.new(:diamonds, :queen) }
  let(:d_K) { Card.new(:diamonds, :king) }
  let(:c_K) { Card.new(:clubs, :king) }
  let(:d_A) { Card.new(:diamonds, :ace)}
  let(:h_A) { Card.new(:hearts, :ace) }
  let(:s_A) { Card.new(:spades, :ace) }
  let(:hand) { Hand.new }
  let(:high_card) { Hand.new([s_2, d_Q, c_9, d_T, h_A])}
  let(:pair) { Hand.new([s_9, d_Q, c_9, d_T, h_A]) }
  let(:low_pair) { Hand.new([s_3, c_3, d_Q, d_T, h_4])}
  let(:two_pair) { Hand.new([s_9, d_Q, c_9, d_T, s_T])}
  let(:three_of_a_kind) { Hand.new([h_A, s_9, s_2, h_9, c_9]) }
  let(:middle_straight) { Hand.new([h_9, d_T, d_Q, s_J, d_8] )}
  let(:high_straight) { Hand.new([d_T, s_J, d_Q, h_A, c_K]) }
  let(:low_straight) { Hand.new([h_4, s_5, h_A, s_2, c_3]) }
  let(:flush) { Hand.new([s_2, s_5, s_9, s_T, s_J]) }
  let(:full_house) { Hand.new([s_9, d_T, s_T, h_9, c_9]) }
  let(:quads) { Hand.new([s_9, h_9, s_T, c_9, d_9]) }
  let(:straight_flush) { Hand.new([d_9, d_T, d_Q, d_J, d_8] ) }
  let(:royal_flush) { Hand.new([d_A, d_T, d_Q, d_J, d_K] ) }
  let(:low_straight_flush) { Hand.new([s_2, s_4, s_3, s_A, s_5] ) }

  describe "#initialize" do
    it "should start with no cards" do
      expect(hand.cards).to eq([])
    end

    it "starts with cards when given" do
      expect(Hand.new([s_9, d_Q]).cards).to eq([s_9, d_Q])
    end
  end

  describe "#add_cards" do
    it "should add a card to hand" do
      hand.add_cards([s_9])
      expect(hand.cards).to eq([s_9])
    end

    it "should add multiple cards to hand" do
      hand.add_cards([c_9, h_A])
      expect(hand.cards).to eq([c_9,h_A])
    end
  end

  describe "#hand_rank" do
    it "should find rank of high-card" do
      expect(high_card.hand_rank).to eq([1, 14, 12, 10, 9, 2])
    end

    it "should find rank of pair" do
      expect(pair.hand_rank).to eq([2, 9, 14, 12, 10])
    end

    it "should find rank of two-pair" do
      expect(two_pair.hand_rank).to eq([3, 10, 9, 12])
    end

    it "should find rank of three-of-a-kind" do
      expect(three_of_a_kind.hand_rank).to eq ([4, 9, 14, 2])
    end

    describe "straight ranks" do
      it "should find rank of straight" do
        expect(middle_straight.hand_rank).to eq([5, 12])
      end

      it "should find rank of ace-high straight" do
        expect(high_straight.hand_rank).to eq([5, 14])
      end

      it "should find rank of ace-5 straight" do
        expect(low_straight.hand_rank).to eq([5, 5])
      end
    end

    it "should find rank of flush" do
      expect(flush.hand_rank).to eq([6, 11, 10, 9, 5, 2])
    end

    it "should find rank of full house" do
      expect(full_house.hand_rank).to eq([7, 9, 10])
    end

    it "should find rank of four-of-a-kind" do
      expect(quads.hand_rank).to eq([8, 9, 10])
    end

    describe "straight flush" do
      it "should find rank of straight-flush" do
        expect(straight_flush.hand_rank).to eq([9, 12])
      end

      it "should find rank of royal_flush" do
        expect(royal_flush.hand_rank).to eq([9, 14])
      end

      it "should find rank of ace-5 straight_flush" do
        expect(low_straight_flush.hand_rank).to eq([9, 5])
      end

    end
  end

  describe "#<=>" do
    it "should have straight flush be higher than three of a kind" do
      expect(straight_flush > three_of_a_kind).to be_true
    end

    it "should have a three of a kind not be higher than a straight flush" do
      expect(three_of_a_kind > straight_flush).to be_false
    end

    it "should have a higher pair be better than a lower pair" do
      expect(pair > low_pair).to be_true
    end

    it "should rank an ace-5 straight lower than a middle straight" do
      expect(low_straight < middle_straight).to be_true
    end
  end

end