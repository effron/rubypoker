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
    @active_players = players
    ante_up
    deck.reshuffle
    deal_cards
    display_hands
    betting_round
    display_hands
    discard_round
    display_hands
    betting_round
    payout_winner(choose_winner)
    display_hands
  end
  
  def display_hands
    @active_players.each_with_index do |player, i|
      puts "Player #{ i + 1 }: #{player.hand}"
    end      
  end

  def payout_winner(winner)
    winner.collect_winnings(@pot)
    @pot = 0
  end

  def ante_up(ante = @ante)
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
      player.hand.cards = []
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
    first_round = true
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
        players_owe_hash[player] = current_bet * -1
        calls_in_a_row += 1
      when :fold
        fold(player)
      else
        player.bet(players_owe_hash[player] + response[1])
        @pot += (players_owe_hash[player] + response[1])
        current_bet += response[1]

        calls_in_a_row = 0
        players_owe_hash[player] = current_bet * -1
      end
      if player == @active_players.last
        first_round = false
      end
      break if calls_in_a_row == @active_players.length - 1 && !first_round
      break if calls_in_a_row == @active_players.length         
      break if @active_players.length == 1            
    end
  end

  def fold(player)
    @active_players.delete(player)
  end

end