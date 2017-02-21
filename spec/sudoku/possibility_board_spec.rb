require 'spec_helper'
require 'sudoku/game_board'
require 'sudoku/possibility_board'

module Sudoku
  RSpec.describe PossibilityBoard do
    it "returns the correct unknown values" do
      board = GameBoard.new(0, 3, 4, 9, 7, 6, 5, 8, 0,
                            9, 7, 0, 2, 8, 5, 3, 6, 4,
                            8, 5, 6, 4, 3, 1, 2, 9, 7,
                            6, 2, 9, 1, 4, 8, 7, 3, 5,
                            0, 8, 5, 3, 6, 7, 9, 4, 2,
                            3, 4, 7, 5, 9, 2, 6, 1, 8,
                            4, 9, 8, 7, 2, 3, 1, 5, 6,
                            7, 1, 3, 6, 5, 4, 8, 2, 9,
                            5, 6, 2, 8, 1, 9, 4, 7, 3)

      pboard = PossibilityBoard.new(board.possible_values)

      expect(pboard.unknown_values.size).to eq(1)
      expect(pboard.unknown_values.first.value).to eq(Set.new([1, 2]))
      expect(pboard.best_to_try.value).to eq(Set.new([1, 2]))
      expect(pboard.best_to_try.coordinates).to eq(Coordinates.new(0, 0))
      expect(pboard.solved?).to be_falsy
    end

    it "says invalid board is invalid" do
      board = GameBoard.new(8, 3, 4, 9, 7, 6, 5, 1, 1,
                            9, 7, 1, 2, 8, 5, 3, 6, 4,
                            8, 5, 6, 4, 3, 1, 2, 9, 7,
                            6, 2, 9, 1, 4, 8, 7, 3, 5,
                            4, 8, 5, 3, 6, 7, 9, 4, 2,
                            3, 4, 7, 5, 9, 2, 6, 1, 8,
                            4, 9, 8, 7, 2, 3, 1, 5, 6,
                            7, 1, 3, 6, 5, 4, 8, 2, 9,
                            5, 6, 2, 8, 1, 9, 4, 7, 3)

      pboard = PossibilityBoard.new(board.possible_values)

      expect(pboard.valid?).to be_falsy
      expect(pboard.solved?).to be_falsy
      expect(pboard.completed?).to be_truthy
    end
  end
end
