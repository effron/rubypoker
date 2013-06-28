require 'rspec'
require './lib/my_array.rb'


describe "#my_uniq" do
  it "doesn't change uniq array" do
    expect([1,2,3].my_uniq).to eq([1,2,3])
  end

  it "doesn't return dupes" do
    expect([1,1,2,2,3].my_uniq).to eq([1,2,3])
  end

  it "works on non-ordered arrays" do
    expect([5,4,1,5,2,1].my_uniq).to eq([5,4,1,2])
  end
end

describe "#two_sum" do
  it "works on a single pair" do
    expect([-2,2].two_sum).to eq([[0,1]])
  end

  it "works on a longer array" do
    expect([-1, 0, 2, -2, 1].two_sum).to eq([[0, 4], [2, 3]])
  end

  it "works on arrays without pairs" do
    expect([1,2,3,4,5].two_sum).to eq([])
  end

  it "ignores single zeroes" do
    expect([0, 1, -1].two_sum).to eq([[1,2]])
  end

  it "still counts two zeroes" do
    expect([0, 1, -1, 3, 0].two_sum).to eq([[0, 4], [1,2]])
  end
end

# describe "Towers of Hanoi" do
#   context "#game_over?" do
#
#
#     it "returns true when game is over" do
#
#     end
#   end
#
# end
#

