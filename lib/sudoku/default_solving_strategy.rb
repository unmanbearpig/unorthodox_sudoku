module Sudoku
  class DefaultSolvingStrategy
    attr_reader :board
    def initialize(board)
      @board = board
    end

    def unknown_values
      @unknown_values ||=
        board.unknown_values
        .sort_by! { |v| v.value.size }
    end

    def most_common_unknown_values
      @most_common_unknown_values ||=
        unknown_values.flat_map(&:value).flat_map(&:to_a).sort.reduce(Hash.new(0)) do |acc, value|
        acc[value] += 1
        acc
      end
    end

    def occurence_among_unknown_values(value)
      most_common_unknown_values[value]
    end

    def size_of_smallest_set_of_unknown_values
      @size_of_smallest_set_of_unknown_values ||= unknown_values.first.value.size
    end

    def smallest_set_of_unknown_values
      @smallest_set_of_unknown_values ||=
        unknown_values.select { |v| v.value.size == size_of_smallest_set_of_unknown_values }
    end

    def best_combinations_to_try
      return @best_combinations_to_try if @best_combinations_to_try
      return nil unless unknown_values.any?

      @best_combinations_to_try =
        smallest_set_of_unknown_values
          .sort_by { |v| v.value.map(&method(:occurence_among_unknown_values)) }
    end

    def best_permutations_to_try
      @best_permutations_to_try ||= best_combinations_to_try&.permutation
    end

    def board_permutations
      return @board_permutations if @board_permutations
      best = best_permutations_to_try
      return nil unless best

      @board_permutations = best.lazy.flat_map do |combinations|
        combinations.flat_map do |possibility_set|
          coordinates = possibility_set.coordinates
          possibility_set.value.map { |value| board.set(coordinates, value) }
        end
      end
    end

    def solve_possibility_board
      return board if board.solved?
      return nil if board.completed?

      board_permutations.each do |new_board|
        result = self.class.new(new_board).solve_possibility_board
        return result if result
      end

      nil
    end
  end
end
