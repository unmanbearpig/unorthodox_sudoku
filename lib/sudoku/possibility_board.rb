require 'sudoku/game_board'

module Sudoku
  class PossibilityBoard
    attr_reader :grid
    def initialize(grid_of_possibilities)
      @grid = grid_of_possibilities
    end

    def set(coordinates, new_set_or_value)
      new_set = new_set_or_value.kind_of?(Set) ? new_set_or_value : Set[new_set_or_value]
      self.class.new(grid.set(coordinates, new_set))
    end

    def to_board
      values = grid.values.map do |set, coordinates|
        if set.size == 1
          set.first
        else
          0
        end
      end.to_a
      GameBoard.new(*values)
    end

    def unknown_values
      @unknown_values ||=
        grid.with_coordinates
          .reject { |v| v.value.size == 1 }
    end

    def solved?
      completed? && valid?
    end

    def completed?
      grid.values.map(&:size).all? { |size| size == 1 }
    end

    def valid?
      grid.domains.all? { |d| d.reduce(:+).count == 9 }
    end
  end
end
