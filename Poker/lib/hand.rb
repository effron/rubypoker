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
    cards.map!{ |card| card.poker_value}
  end

  def pair_rank
    pair_value = @cards.select { |card| @cards.count(card) == 2 }.first.poker_value
    other_cards = @cards.select { |card| @cards.count(card) == 1 }
    other_values = other_cards.map { |card| card.poker_value }
    [2, pair_value] + other_values.sort.reverse
  end

  def high_card_rank
    values = @cards.map { |card| card.poker_value }
    [1] + values.sort.reverse
  end

  def two_pair_rank
    pair_cards = @cards.select{ |card| @cards.count(card) == 2 }
    pair_values = pair_cards.map{ |card| card.poker_value }.uniq
    other_value = @cards.find{ |card| @cards.count(card) == 1 }.poker_value
    [3] + pair_values.sort.reverse << other_value
  end

  def three_of_a_kind_rank
    set_value = @cards.find{ |card| @cards.count(card) == 3 }.poker_value
    other_cards = @cards.select{ |card| @cards.count(card) == 1 }
    other_values = other_cards.map{ |card| card.poker_value }
    [4, set_value] + other_values.sort.reverse
  end

  def straight_rank
    values = @cards.map{ |card| card.poker_value }
    values.sort!
    return [5, 5] if values == [2, 3, 4, 5, 14]
    [5, values.last]
  end

  def flush_rank
    values = @cards.map{ |card| card.poker_value }
    [6] + values.sort.reverse
  end

  def full_house_rank
    trips_value = @cards.find{ |card| @cards.count(card) == 3 }.poker_value
    pair_value = @cards.find{ |card| @cards.count(card) == 2 }.poker_value
    [7, trips_value, pair_value]
  end

  def four_of_a_kind_rank
    quads_value = @cards.find{ |card| @cards.count(card) == 4 }.poker_value
    last_value = @cards.find{ |card| @cards.count(card) == 1 }.poker_value
    [8, quads_value, last_value]
  end

  def straight_flush_rank
    values = @cards.map{ |card| card.poker_value }
    values.sort!
    return [9, 5] if values == [2, 3, 4, 5, 14]
    [9, values.last]
  end

  def <=>(other_hand)
    hand_rank.each_with_index do |rank, i|
      next if rank == other_hand.hand_rank[i]
      return rank <=> other_hand.hand_rank[i]
    end
  end

  def discard(discard_cards)
    cards_there = discard_cards.all? do |discard_card|
      @cards.any? do |card|
        card.eql?(discard_card)
      end
    end
    raise HandError unless cards_there
    @cards -= discard_cards
  end

end

class HandError < StandardError
end