require 'sudoku/game_board'
require 'sudoku/possibility_board'
module Sudoku
  class Game
    def load_board(*board_values)
      @board = GameBoard.new(*board_values)
    end

    def solve
      pboard = PossibilityBoard.new(@board.possible_values)
      solve_possibility_board(pboard).to_board
    end

    def make_board_permutations(board)
      best = board.best_permutations_to_try
      return nil unless best

      best.lazy.flat_map do |combinations|
        combinations.flat_map do |possibility_set|
          coordinates = possibility_set.coordinates
          possibility_set.value.map { |value| board.set(coordinates, value) }
        end
      end
    end

    def solve_possibility_board(board)
      return board if board.solved?
      return nil if board.completed?

      boards = make_board_permutations(board)
      boards.each do |new_board|
        result = solve_possibility_board(new_board)
        return result if result
      end

      nil
    end
  end
end
