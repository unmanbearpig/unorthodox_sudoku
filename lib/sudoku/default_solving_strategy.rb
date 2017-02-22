module Sudoku
  class DefaultSolvingStrategy
    attr_reader :board
    def initialize(board)
      @board = board
    end

    def solve_possibility_board
      return board if board.solved?
      return nil if board.completed?

      board_permutations.map do |new_board|
        self.class.new(new_board).solve_possibility_board
      end.reject(&:nil?).first
    end

    def board_permutations
      @board_permutations ||= best_permutations_to_try.lazy.flat_map do |combinations|
        combinations.flat_map do |cell|
          coordinates = cell.coordinates
          cell.map { |value| board.set(coordinates, value) }
        end
      end
    end

    def best_permutations_to_try
      best_combinations_to_try.permutation
    end

    def best_combinations_to_try
      return nil unless unknown_values.any?

      @best_combinations_to_try ||=
        smallest_set_of_unknown_values
          .sort_by { |v| v.map(&method(:occurence_among_unknown_values)) }
    end

    def smallest_set_of_unknown_values
      smallest_set_size = unknown_values.first.size

      @smallest_set_of_unknown_values ||=
        unknown_values.select { |v| v.size == smallest_set_size }
    end

    def occurence_among_unknown_values(value)
      most_common_unknown_values[value]
    end

    def most_common_unknown_values
      @most_common_unknown_values ||=
        unknown_values.flat_map(&:to_a).sort
          .reduce(Hash.new(0)) { |acc, value| acc[value] += 1; acc }
    end

    def unknown_values
      @unknown_values ||= board.unknown_values.sort_by!(&:size)
    end
  end
end
