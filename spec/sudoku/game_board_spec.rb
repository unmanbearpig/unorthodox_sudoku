require "spec_helper"
require 'sudoku/game'
require 'sudoku/game_board'

module Sudoku
  describe GameBoard do
    describe "#==" do
      it "is equal to the board with same values" do
        values = [0, 7, 8, 3, 4, 2, 9, 5, 0,
                  3, 2, 9, 1, 8, 5, 7, 6, 4,
                  4, 5, 0, 7, 6, 9, 8, 2, 3,
                  5, 1, 6, 4, 7, 3, 2, 8, 9,
                  8, 3, 7, 9, 2, 6, 4, 1, 5,
                  9, 4, 2, 8, 5, 1, 6, 3, 7,
                  7, 6, 5, 2, 1, 4, 3, 9, 8,
                  2, 9, 4, 5, 3, 8, 1, 7, 6,
                  0, 8, 3, 6, 9, 7, 5, 4, 2]

        expect(GameBoard.new(*values)).to eq(GameBoard.new(*values))
      end
    end
  end
end
