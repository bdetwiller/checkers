
class Piece
  attr_accessor :location
  attr_reader :vectors, :color, :symbol
  def initialize(location, color)
    @location = location
    @color = color
    @symbol = ' * '
    set_vector
  end
  
  def set_vector
    if @color == :red
      @vectors = [[1, 1], [1, -1]]
    else
      @vectors = [[-1, 1], [-1, -1]]
    end
  end
  
  def make_king
    @vectors = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
    @symbol = ' @ '
  end
  
end
