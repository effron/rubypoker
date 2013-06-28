class Towers
  attr_accessor :towers

  def initialize
    @towers = [[1,2,3], [], []]
  end

  def move(start, finish)
    raise InvalidMoveError if @towers[start].empty?
    piece = @towers[start].shift
    if @towers[finish].last.nil? ||  @towers[finish].last > piece
      @towers[finish].unshift(piece)
    else
      @towers[start].unshift(piece)
    end
  end

  def won?
    @towers == [[],[],[1,2,3]]
  end

end

class InvalidMoveError < StandardError
end