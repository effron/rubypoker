require 'rspec'
require 'game'

describe Game do
  let(:deck) { double "deck" }
  let(:player_1) { double "player1", :bet => nil}
  let(:player_2) { double "player2", :bet => nil }
  let(:game) { Game.new(deck, [player_1, player_2]) }



  context "#pot" do
    it "Tells you how big the pot is" do
      expect(game.pot).to eq(0)
    end
  end

  context '#players' do
    it "Has players" do
      expect(game.players).to be_an_instance_of(Array)
    end
  end

  context '#ante_up' do
    it "takes a bet from a player" do
      game.players[0].should_receive(:bet) { 50 }
      game.ante_up(50)
    end

    it "grows the pot after ante" do
      game.ante_up(5)
      expect(game.pot).to eq(10)
    end
  end





end