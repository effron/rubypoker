require_relative 'hand'

class Player

  attr_accessor :hand, :chips

  def initialize(chips = 0)
    @chips = chips
    @hand = Hand.new
  end

  def bet(bet_amt)
    raise ChipsError.new, "Insufficient Funds" if chips < bet_amt
    @chips -= bet_amt
    bet_amt
  end

  def fold
    @hand = Hand.new
  end

  def respond_to_turn(current_bet, current_chips)
    puts "The current bet is #{current_bet}. The chips is #{current_chips}."
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
    @chips += winnings
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

class ChipsError < StandardError
end

class InputError < StandardError
end