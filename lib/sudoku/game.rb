require 'sudoku/game_board'
require 'sudoku/possibility_board'
module Sudoku
  class Game
    def load_board(*board_values)
      @board = GameBoard.new(*board_values)
    end

    def strategy
      DefaultSolvingStrategy.new(PossibilityBoard.new(@board.possible_values))
    end

    def solve
      strategy.solve_possibility_board.to_board
    end
  end

  class DefaultSolvingStrategy
    attr_reader :board
    def initialize(board)
      @board = board
    end

    def unknown_values
      board.unknown_values
    end

    def most_common_unknown_values
      @most_common_unknown_values ||=
        unknown_values.flat_map(&:value).flat_map(&:to_a).sort.reduce(Hash.new(0)) do |acc, value|
        acc[value] += 1
        acc
      end
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
