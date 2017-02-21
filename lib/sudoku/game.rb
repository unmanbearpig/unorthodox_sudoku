require 'sudoku/game_board'
require 'sudoku/possibility_board'
module Sudoku
  class Game
    def load_board(*board_values)
      @board = GameBoard.new(*board_values)
    end

    def solve
      solve_possibility_board(PossibilityBoard.new(@board.possible_values)).to_board
    end

    def solve_possibility_board(board)
      if board.solved?
        return board
      end

      if board.completed?
        return nil
      end

      best = board.best_combinations_to_try.permutation

      return nil unless best

      best.each do |combinations|
        combinations.each do |possibility_set|

          coordinates = possibility_set.coordinates
          possibility_set.value.each do |value|
            new_board = board.set(coordinates, value)

            result = solve_possibility_board(new_board)

            return result if result
          end
        end
      end

      nil
    end
  end
end
