require 'sudoku/game_board'

module Sudoku
  class PossibilityBoard
    attr_reader :grid
    def initialize(grid_of_possibilities)
      @grid = grid_of_possibilities
    end

    def set(coordinates, new_set_or_value)
      new_set = new_set_or_value.kind_of?(Set) ? new_set_or_value : Set.new([new_set_or_value])
      new_grid = grid.dup
      new_grid[coordinates] = new_set

      self.class.new(new_grid)
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
      grid.with_coordinates
        .reject { |v| v.value.size == 1 }
        .sort_by { |v| v.value.size }.reverse
    end

    def solved?
      completed? && valid?
    end

    def completed?
      unknown_values.size == 0
    end

    def valid?
      number_grid = to_board.grid
      number_grid.rows.all? { |r| r.sort.uniq.count == 9 }
      number_grid.columns.all? { |r| r.sort.uniq.count == 9 }
      number_grid.groups.all? { |r| r.sort.uniq.count == 9 }
    end

    def best_combinations_to_try
      return nil unless unknown_values.any?

      smallest_size = unknown_values.first.value.size
      unknown_values.select { |v| v.value.size == smallest_size }
    end
  end
end
