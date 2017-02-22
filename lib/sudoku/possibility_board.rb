require 'sudoku/game_board'
require 'sudoku/cell'

module Sudoku
  class PossibilityBoard
    ALL_CELL_VALUES = Set.new(1..Grid::SIZE).freeze

    attr_reader :grid
    def initialize(grid_of_possibilities)
      @grid = grid_of_possibilities
    end

    def self.possible_values_for(grid, coordinates)
      ALL_CELL_VALUES - Set.new(grid.domains_of(coordinates)) - Set.new([0])
    end

    def self.possible_values_of(grid)
      grid.map do |value, coordinates|
        if value == 0
          Cell.new(possible_values_for(grid, coordinates), coordinates)
        else
          Cell.new((value), coordinates)
        end
      end
    end

    def self.from_game_board(board)
      new(possible_values_of(board.grid))
    end

    def set(coordinates, new_value)
      self.class.new(grid.set(coordinates, Cell.new(new_value, coordinates)))
    end

    def to_board
      GameBoard.new(*grid.values.map(&:to_i))
    end

    def unknown_values
      @unknown_values ||= grid.values.reject(&:known?)
    end

    def solved?
      completed? && valid?
    end

    def completed?
      grid.values.all?(&:known?)
    end

    def valid?
      grid.domains.all? { |d| d.reduce(:+).count == Grid::SIZE }
    end
  end
end
