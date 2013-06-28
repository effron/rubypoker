require 'rspec'
require 'hand'

describe Hand do
  let(:deck) { double("deck", :draw(n) => [Card.new("suit","value"), Card.new("suit", "value")] }



end