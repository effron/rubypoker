require 'rspec'
require 'player'

describe Player do
  let(:player) { Player.new }
  let(:rich_player) {Player.new(500) }
  let(:hand) { double("hand", :cards => ["ace","queen", "ten", "four", "two"])}

  describe "#initialize" do
    it "Defaults to empty hand" do
      expect(player.hand).to be_an_instance_of(Hand)
    end

    it "Defaults to zero pot" do
      expect(player.pot).to eq(0)
    end

    it "Allows setting specific pot" do
      player_1 = Player.new(50)
      expect(player_1.pot).to eq(50)
    end
  end

  describe "#bet" do
    it "Lowers your pot when you bet" do
      rich_player.bet(10)
      expect(rich_player.pot).to eq(490)
    end

    it "Doesn't let you bet bigger than your pot" do
      expect { rich_player.bet(600) }.to raise_error(PotError)
    end
  end

  describe "#collect_winnings" do
    it "Adds money to your pot" do
      player.collect_winnings(500)
      expect(player.pot).to eq(500)
    end
  end

  describe "#parse_input" do
    it "Parses 'call' properly" do
      expect(player.parse_input("call")).to eq(:call)
    end

    it "Parses 'fold' properly" do
      expect(player.parse_input("fold")).to eq(:fold)
    end

    it "Parses 'raise 500' properly" do
      expect(player.parse_input("raise 500")).to eq([:raise, 500])
    end

    it "Doesn't allow for weird input" do
      expect { player.parse_input("plop") }.to raise_error(InputError)
    end
  end

  describe "#fold" do
    it "Resets player's hand" do
      player.hand = hand
      player.fold
      expect(player.hand.cards).to be_empty
    end
  end

  describe "#parse_discards" do
    it "Takes a string of card_locations, returns an array of card objects" do
      player.hand = hand
      expect(player.parse_discards("0,1,2")).to eq(["ace","queen","ten"])
    end

    it "Raises error with improper string" do
      expect { player.parse_discards("hello") }.to raise_error(InputError)
    end
  end


end



