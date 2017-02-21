require 'sudoku/game_board'

module Sudoku
  class Game
    def load_board(*board_values)
      @board = GameBoard.new(board_values)
    end

    def solve
    end
  end
end
