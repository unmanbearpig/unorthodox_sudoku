require 'set'
require 'sudoku/grid'

module Sudoku
  class GameBoard
    SIZE = 9.freeze

    attr_reader :grid
    def initialize(*board_values)
      @grid = Grid.new(board_values)
    end

    def possible_values_for(coordinates)
      all_values = Set.new(1..9)

      row_values = Set.new(grid.row(coordinates)) - Set.new([0])
      column_values = Set.new(grid.column(coordinates)) - Set.new([0])
      group_values = Set.new(grid.group_for(coordinates)) - Set.new([0])

      all_values - row_values - column_values - group_values
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
