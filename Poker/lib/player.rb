require_relative 'hand'

class Player

  attr_accessor :hand, :pot

  def initialize(pot = 0)
    @pot = pot
    @hand = Hand.new
  end

  def bet(bet_amt)
    raise PotError.new, "Insufficient Funds" if pot < bet_amt
    @pot -= bet_amt
    bet_amt
  end

  def fold
    @hand = Hand.new
  end

  def respond_to_turn(current_bet, current_pot)
    puts "The current bet is #{current_bet}. The pot is #{current_pot}."
    puts "Raise \#{amount}, call, or fold?"
    parse_input(gets.chomp.downcase)
  end

  def respond_to_which_cards
    puts "Which cards do you want to discard?"
    prase_discards(gets.chomp)
  end

  def parse_discards(card_locations)
    unless card_locations =~ /^[0-4],?([0-4],)*[0-4]?$/
      raise InputError, "Improper card locations"
    end
    card_loc_array = card_locations.split(",").map(&:to_i)
    card_loc_array.map{ |index| hand.cards[index]}
  end

  def collect_winnings(winnings)
    @pot += winnings
  end

  def parse_input(string)
    return :call if string == "call"
    return :fold if string == "fold"
    if string =~ /raise\s\d+/
      bet_array = string.split(" ")
      return [:raise, bet_array[1].to_i]
    end
    raise InputError.new, "Not recognizeable input"
  end

end

class PotError < StandardError
end

class InputError < StandardError
end