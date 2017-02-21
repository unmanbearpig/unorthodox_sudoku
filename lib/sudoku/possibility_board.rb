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
          .sort_by! { |v| v.value.size }
    end

    def most_common_unknown_values
      @most_common_unknown_values ||=
        unknown_values.flat_map(&:value).flat_map(&:to_a).sort.reduce(Hash.new(0)) do |acc, value|
        acc[value] += 1
        acc
      end
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

    def best_combinations_to_try
      return nil unless unknown_values.any?

      smallest_size = unknown_values.first.value.size

      unknown_values.select { |v| v.value.size == smallest_size }
        .sort_by { |v| v.value.map { |num| most_common_unknown_values[num] } }
    end

    def best_permutations_to_try
      @best_permutations_to_try ||= best_combinations_to_try&.permutation
    end
  end
end
