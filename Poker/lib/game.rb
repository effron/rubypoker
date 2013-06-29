require_relative 'player'

class Game
  attr_reader :pot, :players, :deck, :ante, :active_players

  def initialize(deck, players, pot = 0, ante = 0)
    @deck = deck
    @pot = pot
    @players = players
    @ante = ante
    @active_players = players
  end

  def play
    ante_up(@ante)
    deck.shuffle
    deal_cards
    betting_round
    discard_round
    betting_round
    choose_winner
  end

  def ante_up(ante)
    @ante = ante
    @players.each do |player|
      player.bet(ante)
    end

    @pot += @players.size * ante
  end
  
  def choose_winner
    @active_players.max_by { |player| player.hand }
  end

  def deal_cards
    @players.each do |player|
      player.hand.add_cards(@deck.draw(5))
    end
  end
  
  def discard_round
    @players.each do |player|
      next unless @active_players.include?(player)
      discards = player.respond_to_which_cards
      player.hand.discard(discards)
      player.hand.add_cards(@deck.draw(discards.length))
    end
  end
  
  def betting_round
    current_bet = 0
    calls_in_a_row = 0
    players_owe_hash = Hash.new(0)
    @active_players.each do |player|
      players_owe_hash[player] = 0
    end
    
    @players.cycle do |player|
      next unless @active_players.include?(player)
      players_owe_hash[player] += current_bet
      response = player.respond_to_turn(players_owe_hash[player], @pot)
      case response
      when :call
        player.bet(players_owe_hash[player])
        @pot += players_owe_hash[player]
        players_owe_hash[player] -= current_bet
        calls_in_a_row += 1
      when :fold
        fold(player)
      else
        current_bet = response[1]
        player.bet(players_owe_hash[player])
        @pot += current_bet
        calls_in_a_row = 0
        players_owe_hash[player] -= current_bet
      end
      break if calls_in_a_row == @active_players.length        
      break if @active_players.length == 1            
    end
  end

  def fold(player)
    @active_players.delete(player)
  end

end