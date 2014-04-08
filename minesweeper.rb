=begin
10 Mines, 81 squares, distributed randomly.

Reveal = Spacebar, Flag = f

Classes: Tile, Board, User, Game

Tile Class:
def reveal
def neighbors
def neighbor_bomb_count


Board Class:
def print_board
def create_new_board
def seed_bombs
def process_guess


Game Class:
def play
def save
def load
def guess
def place_flag

=end

require 'debugger'
require 'yaml'

class Board
  attr_accessor :board

  def initialize
    @board = create_new_board
  end

  def create_new_board
    board = Array.new(9) { Array.new(9) }

    bomb_positions = seed_bombs

    bomb_positions.each do |position|
      board[ position[0] ][ position[1] ] = Tile.new(position, true)
    end

    board.each_with_index do |row, idx|
      row.each_with_index do |tile, idx2|
        board[idx][idx2] = Tile.new([idx, idx2]) if tile.nil?
      end
    end
  end

  def seed_bombs
    list = []
    until list.length == 10
      location = [rand(9), rand(9)]
      list << location unless list.include?(location)
    end
    list
  end

  def neighbor_bomb_count(position)
    count = 0
    current_tile = board[position[0]][position[1]]
    neighbors = current_tile.neighbors_locations
    neighbors.each do |neighbor|
      count += 1 if board[neighbor[0]][neighbor[1]].bomb == true
    end
    count
  end

  def unrevealed_neighbors(position)
    current_tile = @board[position[0]][position[1]]
    neighbors = current_tile.neighbors_locations
    neighbors.select { |x| board[x[0]][x[1]].revealed == false }
  end

  def normalize_neighbors(arr)
    objects_array = []
    arr.each do |neighbor_pos|
      objects_array << @board[neighbor_pos[0]][neighbor_pos[1]]
    end
    objects_array
  end

  def print_board

    puts

    puts "   0  1  2  3  4  5  6  7  8 "

    @board.each_with_index do |row, idx|
      print "#{idx} "
      row.each do |tile|
        print " #{tile.print_tile} "
      end
      puts "\n"
    end

    puts "\n\n"
  end

end

class Tile
  attr_reader :position, :bomb, :neighbors
  attr_accessor :revealed, :flagged, :num_surrounding_bombs

  def initialize(position, bomb = false, revealed = false, flagged = false)
    @position = position
    @bomb = bomb
    @neighbors = neighbors_locations
    @revealed = revealed
    @flagged = flagged
    @num_surrounding_bombs = nil
  end

  def neighbors_locations
    deltas = [[-1, 1], [0, 1], [1, 1], [-1, 0], [-1, -1], [1, -1], [1, 0], [0, -1]]
    neighbors = deltas.map do |dx, dy|
      [position[0] + dx, position[1] + dy]
    end
    neighbors.select { |value| on_board?(value) }
  end

  def on_board?(position)
    return false if position[0] < 0 || position[0] > 8
    return false if position[1] < 0 || position[1] > 8
    true
  end

  def print_tile
    if @revealed == false && @flagged == false
      return "_"

    elsif @flagged == true
      return "F"

    elsif @revealed == true && @bomb == true
      return "x"

    elsif @num_surrounding_bombs != nil && @revealed == true && @num_surrounding_bombs > 0
      return "#{num_surrounding_bombs}"

    elsif @revealed == true && @num_surrounding_bombs == 0 && @bomb != true
      return "o"
    end
  end

end

class Game

  attr_accessor :my_board

  def initialize
    @my_board = Board.new
    @win = false
    @lose = false
    self.set_surronding_bomb_count
    self.greeting_sequence
  end

  def greeting_sequence
    puts "\n\n\nWelcome to Minesweeper\n\n\n\n"
    puts "Would you like to load? Input L if so: "
    input = gets.chomp.downcase
    puts "\n\n\n"
    if input == 'l'
      #initiate load sequence
    else
      self.input_move
    end
  end

  def set_surronding_bomb_count
    @my_board.board.each_with_index do |a, row|
      a.each_with_index do |b, column|
        bombs = @my_board.neighbor_bomb_count([row, column])
        b.num_surrounding_bombs = bombs
      end
    end
  end

  def reveal_tile(position)
    current_tile = @my_board.board[position[0]][position[1]]
    surrounding_bombs_total = @my_board.neighbor_bomb_count(position)

    if current_tile.bomb
      current_tile.revealed = true
      @lose = true
    elsif current_tile.flagged
      current_tile.revealed = false
    elsif surrounding_bombs_total > 0
      current_tile.revealed = true
      current_tile.num_surrounding_bombs = surrounding_bombs_total

    else
      current_tile.revealed = true
      urn = @my_board.unrevealed_neighbors([position[0],position[1]])
      urn.each { |x| self.reveal_tile( x ) }
    end
  end

  def win_checker
    count = 0
    self.my_board.board.each do |row|
      row.each do |tile|
        count += 1 if tile.revealed
      end
    end
    @won = true if count == 71
  end

  def input_move
    until @won || @lose
      self.my_board.print_board
      puts "Please enter your first move in following form:"
      puts "3,1 for Row: 3, Column: 1"
      puts "For flags 1,1,f"
      user_input = gets.chomp
      user_input =  user_input.split(",")
      if user_input.length == 2
        reveal_tile([user_input[0].to_i, user_input[1].to_i])
      elsif user_input.length == 3
        #place flag at that location
        @my_board.board[(user_input[0].to_i)][user_input[1].to_i].flagged = true
      end
      self.win_checker
      def win_sequence
        puts "You win!\n\n"
        self.my_board.print_board
        puts "You win!\n\n"
      end

      def lose_sequence
        puts "You suck.\n\n"
        self.my_board.print_board
        puts "You suck.\n\n"
      end
    end
    if @won
      win_sequence
    elsif @lose
      lose_sequence
    end
  end

end

a = Game.new
