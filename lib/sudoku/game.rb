require 'sudoku/game_board'
require 'sudoku/possibility_board'
require 'sudoku/default_solving_strategy'

module Sudoku
  class Game
    def load_board(*board_values)
      @board = GameBoard.new(*board_values)
    end

    def strategy
      DefaultSolvingStrategy.new(PossibilityBoard.from_game_board(@board))
    end

    def solve
      strategy.solve_possibility_board.to_board
    end
  end
end
