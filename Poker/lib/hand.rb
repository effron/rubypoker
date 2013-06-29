require_relative 'deck'

class Hand
  include Comparable
  attr_accessor :cards

  def initialize(cards = [])
    @cards = cards
  end

  def add_cards(cards)
    @cards += cards
  end
  
  def to_s
    @cards.to_s
  end

  def hand_rank
    case
    when straight_flush?
      straight_flush_rank
    when four_of_a_kind?
      four_of_a_kind_rank
    when full_house?
      full_house_rank
    when flush?
      flush_rank
    when straight?
      straight_rank
    when three_of_a_kind?
      three_of_a_kind_rank
    when two_pair?
      two_pair_rank
    when pair?
      pair_rank
    else
      high_card_rank
    end
  end

  def pair?
    @cards.any? { |card| @cards.count(card) == 2 }
  end

  def two_pair?
    @cards.select { |card| @cards.count(card) == 2 }.size == 4
  end

  def three_of_a_kind?
    @cards.any? { |card| @cards.count(card) == 3 }
  end

  def straight?
    values = @cards.map{ |card| card.poker_value }
    values.sort!
    return true if values == [2, 3, 4, 5, 14]
    values.last - values.first == 4
  end

  def flush?
    card_suits = @cards.map{ |card| card.suit }
    card_suits.uniq.length == 1
  end

  def full_house?
    three_of_a_kind? && pair?
  end

  def four_of_a_kind?
    @cards.any? { |card| @cards.count(card) == 4 }
  end

  def straight_flush?
    straight? && flush?
  end

  def single_card_values
    cards = @cards.select{ |card| @cards.count(card) == 1 }
    cards.map{ |card| card.poker_value}.sort.reverse
  end

  def pair_value
    pair_value = @cards.select { |card| @cards.count(card) == 2 }.first.poker_value
  end

  def pair_rank
    [2, pair_value] + single_card_values
  end

  def high_card_rank
    [1] + single_card_values
  end

  def two_pair_rank
    pair_cards = @cards.select{ |card| @cards.count(card) == 2 }
    pair_values = pair_cards.map{ |card| card.poker_value }.uniq
    [3] + pair_values.sort.reverse + single_card_values
  end

  def three_of_a_kind_rank
    set_value = @cards.find{ |card| @cards.count(card) == 3 }.poker_value
    [4, set_value] + single_card_values
  end

  def values
    @cards.map{ |card| card.poker_value }.sort
  end

  def straight_rank
    return [5, 5] if wheel?
    [5, values.last]
  end

  def flush_rank
    [6] + single_card_values
  end

  def full_house_rank
    trips_value = @cards.find{ |card| @cards.count(card) == 3 }.poker_value
    [7, trips_value, pair_value]
  end

  def four_of_a_kind_rank
    quads_value = @cards.find{ |card| @cards.count(card) == 4 }.poker_value
    [8, quads_value] + single_card_values
  end
  
  def wheel?
    values == [2, 3, 4, 5, 14]
  end

  def straight_flush_rank
    return [9, 5] if wheel?
    [9, values.last]
  end

  def <=>(other_hand)
    hand_rank.each_with_index do |rank, i|
      next if rank == other_hand.hand_rank[i]
      return rank <=> other_hand.hand_rank[i]
    end
  end

  def discard(discard_cards)
    raise HandError unless all_cards_there?(discard_cards)
    @cards -= discard_cards
  end
  
  def all_cards_there?(discard_cards)
    discard_cards.all? do |discard_card|
      @cards.any? do |card|
        card.eql?(discard_card)
      end
    end
  end

end

class HandError < StandardError
end