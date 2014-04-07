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


User Class:
def guess
def place_flag


Game Class:
def play
def save
def load
=end


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

  def print_board
    @board.each do |row|
      row.each do |tile|
        print " #{tile.print_tile} "
      end
      puts
    end
  end

end

class Tile
  attr_reader :position, :bomb, :neighbors, :revealed

  def initialize(position, bomb = false, revealed = false)
    @position = position
    @bomb = bomb
    @neighbors = neighbors_locations
    @revealed = revealed
  end

  def reveal

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
    if @bomb == true
      return "x"
    else
      return "_"
    end
  end

end

b = Board.new

b.print_board
p b.neighbor_bomb_count([1,1])
