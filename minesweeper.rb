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

end

class Tile
  attr_reader :position
  def initialize(position)
    @position = position

  end

  def reveal

  end

  def neighbors
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

  def neighbor_bomb_count

  end

end

a = Tile.new([0,0])
p a.neighbors