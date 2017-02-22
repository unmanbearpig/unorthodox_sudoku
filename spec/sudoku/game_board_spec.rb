require "spec_helper"
require 'sudoku/game'
require 'sudoku/game_board'

module Sudoku
  describe GameBoard do
    let(:values) do
      [0, 0, 8, 3, 4, 2, 9, 0, 0,
       0, 0, 9, 0, 0, 0, 7, 0, 0,
       4, 0, 0, 0, 0, 0, 0, 0, 3,
       0, 0, 6, 4, 7, 3, 2, 0, 0,
       0, 3, 0, 0, 0, 0, 0, 1, 0,
       0, 0, 2, 8, 5, 1, 6, 0, 0,
       7, 0, 0, 0, 0, 0, 0, 0, 8,
       0, 0, 4, 0, 0, 0, 1, 0, 0,
       0, 0, 3, 6, 9, 7, 5, 0, 0]
    end
    subject(:board) { GameBoard.new(*values) }

    describe "#possible_values" do
      it "maps each value on the board to a set of possible values in that position" do
        values = [0, 7, 8, 3, 4, 2, 9, 5, 0,
                  3, 2, 9, 1, 8, 5, 7, 6, 4,
                  4, 5, 0, 7, 6, 9, 8, 2, 3,
                  5, 1, 6, 4, 7, 3, 2, 8, 9,
                  8, 3, 7, 9, 2, 6, 4, 1, 5,
                  9, 4, 2, 8, 5, 1, 6, 3, 7,
                  7, 6, 5, 2, 1, 4, 3, 9, 8,
                  2, 9, 4, 5, 3, 8, 1, 7, 6,
                  0, 8, 3, 6, 9, 7, 5, 4, 2]

        board = GameBoard.new(*values)
        expect(board.possible_values[Coordinates.new(0, 0)]).to eq(Set.new([6, 1]))
      end
    end
  end
end
