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

    describe ".new" do
      it "raises error if input size is invalid" do
        expect do
          GameBoard.new([1, 2, 3])
        end.to raise_error(ArgumentError)
      end
    end

    describe "#[]" do
      it "returns the value of the provided x and y coordinate" do
        expect(board[0, 2]).to eq(8)
        expect(board[0, 3]).to eq(3)
        expect(board[6, 0]).to eq(7)
        expect(board[5, 4]).to eq(5)
      end
    end

    describe "#row" do
      it "returns the row by its index" do
        expect(board.row(0)).to eq([0, 0, 8, 3, 4, 2, 9, 0, 0])
        expect(board.row(6)).to eq([7, 0, 0, 0, 0, 0, 0, 0, 8])
      end
    end

    describe "#column" do
      it "returns the column by its index" do
        expect(board.column(0).count).to eq(9)
        expect(board.column(0)).to eq([0, 0, 4, 0, 0, 0, 7, 0, 0])
        expect(board.column(4)).to eq([4, 0, 0, 7, 0, 5, 0, 0, 9])
      end
    end

    describe "#==" do
      it "is equal to the board with same values" do
        expect(GameBoard.new(*values)).to eq(GameBoard.new(*values))
      end

      it "is not equal to the board with different values" do
        other_values = values.map { |i| i+1 }

        expect(GameBoard.new(*values)).not_to eq(GameBoard.new(*other_values))
      end
    end

    describe "#valid_values" do
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
        expect(board.possible_values[0, 0]).to eq(Set.new([6, 1]))
      end
    end

    describe "#map" do
      it "returns a new board with the values modified by the provided function" do
        result = board.map { |_value| 1 }
        expect(result).to be_kind_of(GameBoard)
        expect(result[0, 0]).to eq(1)
      end
    end

    it "should correctly solve the board" do
      @game = Game.new
      # Each '0' is a blank cell
      @game.load_board 0, 0, 8, 3, 4, 2, 9, 0, 0,
                       0, 0, 9, 0, 0, 0, 7, 0, 0,
                       4, 0, 0, 0, 0, 0, 0, 0, 3,
                       0, 0, 6, 4, 7, 3, 2, 0, 0,
                       0, 3, 0, 0, 0, 0, 0, 1, 0,
                       0, 0, 2, 8, 5, 1, 6, 0, 0,
                       7, 0, 0, 0, 0, 0, 0, 0, 8,
                       0, 0, 4, 0, 0, 0, 1, 0, 0,
                       0, 0, 3, 6, 9, 7, 5, 0, 0
      @solved_board = GameBoard.new 6, 7, 8, 3, 4, 2, 9, 5, 1,
                                    3, 2, 9, 1, 8, 5, 7, 6, 4,
                                    4, 5, 1, 7, 6, 9, 8, 2, 3,
                                    5, 1, 6, 4, 7, 3, 2, 8, 9,
                                    8, 3, 7, 9, 2, 6, 4, 1, 5,
                                    9, 4, 2, 8, 5, 1, 6, 3, 7,
                                    7, 6, 5, 2, 1, 4, 3, 9, 8,
                                    2, 9, 4, 5, 3, 8, 1, 7, 6,
                                    1, 8, 3, 6, 9, 7, 5, 4, 2

      expect(@game.solve).to eq(@solved_board)
    end

    it "should correctly solve the board" do
      @game = Game.new
      # Each '0' is a blank cell
      @game.load_board 0, 0, 4, 0, 0, 0, 5, 0, 0,
                       0, 7, 0, 2, 0, 0, 3, 6, 0,
                       8, 0, 0, 0, 0, 1, 0, 0, 0,
                       6, 2, 9, 0, 0, 0, 0, 3, 0,
                       0, 0, 0, 0, 6, 0, 0, 0, 0,
                       0, 4, 0, 0, 0, 0, 6, 1, 8,
                       0, 0, 0, 7, 0, 0, 0, 0, 6,
                       0, 1, 3, 0, 0, 4, 0, 2, 0,
                       0, 0, 2, 0, 0, 0, 4, 0, 0
      @solved_board = GameBoard.new 2, 3, 4, 9, 7, 6, 5, 8, 1,
                                    9, 7, 1, 2, 8, 5, 3, 6, 4,
                                    8, 5, 6, 4, 3, 1, 2, 9, 7,
                                    6, 2, 9, 1, 4, 8, 7, 3, 5,
                                    1, 8, 5, 3, 6, 7, 9, 4, 2,
                                    3, 4, 7, 5, 9, 2, 6, 1, 8,
                                    4, 9, 8, 7, 2, 3, 1, 5, 6,
                                    7, 1, 3, 6, 5, 4, 8, 2, 9,
                                    5, 6, 2, 8, 1, 9, 4, 7, 3

      expect(@game.solve).to eq(@solved_board)
    end
  end
end
