require 'set'
require 'sudoku/grid'

module Sudoku
  class GameBoard
    SIZE = 9.freeze
    ALL_CELL_VALUES = Set.new(1..SIZE).freeze

    attr_reader :grid
    def initialize(*board_values)
      @grid = Grid.new(board_values)
    end

    def possible_values_for(coordinates)
      ALL_CELL_VALUES - Set.new(grid.intersections(coordinates)) - Set.new([0])
    end

    def possible_values
      return @possible_values if @possible_values

      @possible_values = grid.map do |value, coordinates|
        if value == 0
          possible_values_for(coordinates)
        else
          Set.new([value])
        end
      end
    end
  end
end
