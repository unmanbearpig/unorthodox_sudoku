require 'set'
require 'sudoku/grid'

module Sudoku
  class GameBoard
    attr_reader :grid
    def initialize(*board_values)
      @grid = Grid.new(board_values)
    end

    def ==(other)
      grid == other.grid
    end
  end
end
