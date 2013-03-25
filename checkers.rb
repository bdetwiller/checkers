#REV: So sorry it took me so long. I have been pretty sick and I spaced on this.
#REV: Anyway, your code looks great! Very concise, clear, straightforward. Nice!


require 'colorize'
require 'debugger'
require './piece.rb'
require './board.rb'
# coding: utf-8

class Game
  #REV: conisider having a class method that creates the players & board and passes them into Game.new, creating and kicking off the game.
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
    @over = false #REV: dont think you need @over to be an instance variable.
    #REV: Or a variable at all for that matter. 
    #REV: Actually I would just use: "while true" like you do below.
    #REV: ...that is, unless you are interacting with @over from somewhere else.
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

Game.new.run #REV: with a class method, you would just call that down here.



