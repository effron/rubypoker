require_relative 'player'

class Game
  attr_reader :pot, :players

  def initialize(deck, players, pot = 0)
    @deck = deck
    @pot = pot
    @players = players
  end

  def ante_up(ante)
    @players.each do |player|
      player.bet(ante)
    end

    @pot += @players.size * ante
  end



end