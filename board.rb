
class Board
  attr_accessor :rows
  def initialize
    make_board
    @pieces = []
  end
  
  def make_board
    @rows = Array.new(8) { Array.new(8) }
  end
  
  def setup
    set_pieces(0, :red)
    set_pieces(5, :black)
  end
  
  def set_pieces(row_index, color)
    (row_index..row_index + 2).each do |row|
      8.times do |col|
        next if col.odd? if row.even?
        next if col.even? if row.odd?
        @rows[row][col] = Piece.new([[row],[col]], color)
      end
    end
  end
  
  def render_board
    sq_color = :white
    print "   "
    (0..7).each { |num| print " #{num} "}
    puts

    (0..7).each do |row|
      sq_color = switch_color(sq_color)
      print " #{row} "
      (0..7).each do |col|
        if @rows[row][col].is_a?(Piece)
          piece = @rows[row][col]
          print "#{piece.symbol}".colorize( :color => piece.color, :background => sq_color )
        else
          print "   ".colorize( :background => sq_color )
        end
        sq_color = switch_color(sq_color)
      end
      puts
    end
  end
  
  def switch_color(sq_color)
    sq_color == :white ? :light_yellow : :white
  end
  
  def check_start(selection, color)
    if @rows[selection[0]][selection[1]].nil? || @rows[selection[0]][selection[1]].color != color
      puts "You don't have a piece there"
      return true
    end
  end
  
  def validate(color, start, finish, board)
    piece = board.rows[start[0]][start[1]]
    return false unless board.rows[finish[0]][finish[1]].nil?
    
    piece.vectors.each do |vector|
      slide = [start[0] + vector[0], start[1] + vector[1]]
      return true if check_slide(piece, start, finish, board, slide)
      piece.vectors.each do |vector|
        
        jump = [slide[0] + vector[0], slide[1] + vector[1]]
        next if board.rows[slide[0]][slide[1]].nil?
        return true if check_jump(piece, start, finish, board, slide, jump, color)
      end
    end
    false
  end
  
  def check_slide(piece, start, finish, board, slide)
    if slide == finish    
      move_piece(piece, start, finish, board) 
      return true
    end
  end
  
  def check_jump(piece, start, finish, board, slide, jump, color)
    if board.rows[slide[0]][slide[1]].color != color 
      if jump == finish 
        killed = slide
        move_piece(piece, start, finish, board, killed) 
        return true
      end
    end
  end
  
  def try_move(color, path)
    dup_board = self.duplicate
    count = path.length - 1
    count.times do |i|
      unless validate(color, path[i], path[i + 1], dup_board)
        return false
      end
    end
    #if it never returns false, then the path is valid. Perform move on real board
    count.times do |i|
      validate(color, path[i], path[i + 1], self)
    end
  end  
  
  def move_piece(piece, start, finish, board, killed = nil)
    board.rows[finish[0]][finish[1]] = piece
    piece.location = finish
    board.rows[start[0]][start[1]] = nil
    board.rows[killed[0]][killed[1]] = nil unless killed.nil?
    
    make_king(piece)
  end
  
  def make_king(piece)
    if piece.color == :red && piece.location[0] == 7
      piece.make_king
      "Congrats you have a KING!"
    elsif piece.color == :black && piece.location[0] == 0
      piece.make_king
      "Congrats you have a KING!"
    end 
  end
  
  def duplicate
    new_board = Board.new 
    new_board.rows = self.rows.deep_dup
    new_board
  end
end

class Array
  def deep_dup
    new_array = []
    self.each do |el|
      if el.is_a?(Array)
        new_array << el.deep_dup
      else
        if el.nil?
          new_array << el
        else
          new_array << el.dup
        end
      end
    end

    new_array
  end
end

