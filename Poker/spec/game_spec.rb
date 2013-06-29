require 'rspec'
require 'game'

describe Game do
  let(:deck) { double "deck" , :cards => [], :draw => ["A","Q","1","2","#3"]}
  let(:hand) { double "hand" , :cards => [], :add_cards => nil, :discard => nil, :cards= => []}
  let(:player_1) { double "player1", :bet => nil, :hand => hand, :respond_to_which_cards => ["ace","queen"]}
  let(:player_2) { double "player2", :bet => nil, :hand => hand, :respond_to_which_cards => ["ace","queen"]}
  let(:player_3) { double "player2", :bet => nil, :hand => hand, :respond_to_which_cards => ["ace","queen"]}
  
  let(:game) { Game.new(deck, [player_1, player_2, player_3]) }



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
      expect(game.pot).to eq(15)
    end
  end

  context '#deal_cards' do
    it "deals 5 cards to all players" do
      game.players[0].hand.should_receive(:add_cards).with(["A","Q","1","2","#3"])
      game.deal_cards
    end
  end

  context '#discard_round' do
    it "asks each player which cards to discard" do
      game.players[0].should_receive(:respond_to_which_cards)
      game.discard_round
    end
    
    it "discards cards from players' hands" do
      game.players[0].hand.should_receive(:discard)
      game.discard_round
    end
    
    it "adds new cards to players' hands" do
      game.deck.should_receive(:draw).with(2)
      game.discard_round
    end
  end
  
  context '#betting_round' do
    let(:game) { Game.new(deck, [player_1, player_2, player_3], 50, 5) }
    before(:each) do
      player_1.stub(:respond_to_turn).and_return(:call)
      player_2.stub(:respond_to_turn).and_return(:call) 
      player_3.stub(:respond_to_turn).and_return(:call)
    end
      
    it "asks first player to make a bet" do
      game.players[0].should_receive(:respond_to_turn).with(0, game.pot)
      game.betting_round
    end
    
    it "asks second player to call or raise the bet" do
      game.players[1].should_receive(:respond_to_turn).with(0, game.pot)
      game.betting_round
    end
    
    it "stops asking players when all have called" do
      player_1.should_receive(:respond_to_turn).once
      game.betting_round
    end
    
    it "asks player to call a raised bet" do 
      player_2.stub(:respond_to_turn).and_return([:raise, 100], :call) 
      game.players[2].should_receive(:respond_to_turn).with(100, 150)
      game.betting_round
    end
    
    it "asks player to call a raised bet even if he already called" do
      player_1.stub(:respond_to_turn).and_return([:raise, 50], :call) 
      player_2.stub(:respond_to_turn).and_return([:raise, 100], :call) 
      game.players[0].should_receive(:respond_to_turn).with(100, 400)
      game.betting_round      
    end
    
    it "folds a player when they want to" do
      player_2.stub(:respond_to_turn) { :fold }
      game.should_receive(:fold).with(player_2)
      game.betting_round
    end
  end
  
  context '#fold' do
    it "kicks player out of the round" do
      game.fold(player_1)
      expect(game.active_players.length).to eq(2)
    end
  end

  context '#payout_winner' do
    let(:game) { Game.new(deck, [player_1, player_2, player_3], 500) }
    
    it "empties the pot" do
      player_1.stub(:collect_winnings).and_return(true)
      game.payout_winner(player_1)
      expect(game.pot).to eq(0)
    end
    
    it "pays the winner" do
      player_1.should_receive(:collect_winnings).with(game.pot)
      game.payout_winner(player_1)
    end
  end
  

end