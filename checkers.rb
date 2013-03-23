require 'colorize'
require 'debugger'
require './piece.rb'
require './board.rb'
# coding: utf-8

class Game
  attr_reader :board, :current_player
  def initialize
    @players = {
      :red => Player.new( :red),
      :black => Player.new( :black)
    }
    @board = Board.new
    @current_player = :red
  end
  
  def run
    @board.setup
    @over = false
    until @over
      @board.render_board
      @players[@current_player].play_turn(board)
      @current_player = @current_player == :red ? :black : :red
    end
  end

end

class Player
  attr_reader :color
  def initialize(color)
    @color = color
  end
  
  def play_turn(board)
    puts "#{@color.capitalize} it's your turn:"
    path = get_start(board) + get_finish
    unless board.try_move(@color, path)
      puts "Invalid move try again"
      board.render_board
      play_turn(board)
    end 
  end
  
  def get_start(board)
    array = []
    puts "Enter coordinates of piece you will move (2,2)"
    selection = gets.chomp.split(",").map! {|x| x.to_i}
    get_start(board) if board.check_start(selection, @color)
    array << selection
  end
  
  def get_finish
    array = []
    puts "Enter the coordinates of the first move you want to make (3,3)"
    input = gets.chomp.split(",").map! {|x| x.to_i}
    array << input
    
    while true
      puts "Enter the next move your piece should make (2,2), or 'f' if its path is complete"
      input = gets.chomp
      return array if input == "f"
      array << input.split(",").map! {|x| x.to_i}
    end
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

Game.new.run



