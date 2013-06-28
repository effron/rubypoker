require 'rspec'
require 'towers'

describe Towers do
  let(:game) { Towers.new }


  describe "#new_game" do
    it "starts a new game" do
      expect(game.towers).to eq([[1,2,3],[],[]])
    end
  end

  describe "#move" do
    let(:single_move) do
      game.move(0,1)
      game.towers
    end

    let(:many_moves) do
      game.move(0,1)
      game.move(0,2)
      game.move(1,0)
      game.towers
    end

    let(:illegal_moves) do
      game.move(0,2)
      game.move(0,2)
      game.towers
    end

    it "moves" do
      expect(single_move).to eq([[2,3],[1],[]])
    end

    it "moves pieces around" do
      expect(many_moves).to eq([[1, 3],[],[2]])
    end

    it "doesn't allow illegal moves" do
      expect(illegal_moves).to eq([[2,3],[],[1]])
    end

    it "raises error if tower is empty" do
      expect { game.move(2,3) }.to raise_error(InvalidMoveError)
    end
  end

  describe "#won?" do
    let (:game_winning_sequence) do
      game.move(0,2)
      game.move(0,1)
      game.move(2,1)
      game.move(0,2)
      game.move(1,0)
      game.move(1,2)
      game.move(0,2)
    end

    it "returns false when game isn't over" do
      expect(game.won?).to be_false
    end

    it "returns true when game is won" do
      game_winning_sequence
      expect(game.won?).to be_true
    end

    it "returns false when game isn't over" do
      expect(game.won?).to be_false
    end

  end

end