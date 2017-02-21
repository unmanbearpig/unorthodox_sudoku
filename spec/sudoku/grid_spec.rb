require "spec_helper"
require 'sudoku/grid'

module Sudoku
  describe Grid do
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
    subject(:grid) { Grid.new(values) }

    describe ".new" do
      it "raises error if input size is invalid" do
        expect do
          Grid.new([1, 2, 3])
        end.to raise_error(ArgumentError)
      end
    end

    describe "#[]" do
      it "returns the value of the provided x and y coordinate" do
        expect(grid[Coordinates.new(0, 2)]).to eq(8)
        expect(grid[Coordinates.new(0, 3)]).to eq(3)
        expect(grid[Coordinates.new(6, 0)]).to eq(7)
        expect(grid[Coordinates.new(5, 4)]).to eq(5)
      end
    end

    describe "#row" do
      it "returns the row by its index" do
        expect(grid.row(Coordinates.row(0))).to eq([0, 0, 8, 3, 4, 2, 9, 0, 0])
        expect(grid.row(Coordinates.row(6))).to eq([7, 0, 0, 0, 0, 0, 0, 0, 8])
      end
    end

    describe "#column" do
      it "returns the column by its index" do
        expect(grid.column(Coordinates.col(0)).count).to eq(9)
        expect(grid.column(Coordinates.col(0))).to eq([0, 0, 4, 0, 0, 0, 7, 0, 0])
        expect(grid.column(Coordinates.col(4))).to eq([4, 0, 0, 7, 0, 5, 0, 0, 9])
      end
    end

    describe "#==" do
      it "is equal to the grid with same values" do
        expect(Grid.new(values)).to eq(Grid.new(values))
      end

      it "is not equal to the grid with different values" do
        other_values = values.map { |i| i+1 }

        expect(Grid.new(values)).not_to eq(Grid.new(other_values))
      end
    end

    describe "#map" do
      it "returns a new grid with the values modified by the provided function" do
        result = grid.map { |_value| 1 }
        expect(result).to be_kind_of(Grid)
        expect(result[Coordinates.new(0, 0)]).to eq(1)
      end
    end

    describe ".index_to_group_range" do
      it "returns the group range for index" do
        expect(Grid.index_to_group_range(0)).to eq(0..2)
        expect(Grid.index_to_group_range(4)).to eq(3..5)
        expect(Grid.index_to_group_range(8)).to eq(6..8)
      end
    end

    describe "#group_for" do
      it "returns the list of numbers in that 3x3 group" do
        expect(grid.group_for(Coordinates.new(0, 0))).to eq([0, 0, 8,
                                                             0, 0, 9,
                                                             4, 0, 0])

        expect(grid.group_for(Coordinates.new(4, 7))).to eq([2, 0, 0,
                                                             0, 1, 0,
                                                             6, 0, 0,])

      end
    end

    describe "#intersections" do
      it "returns values from provided row, column and group" do
        coordinates = Coordinates.new(4, 7)
        expect(grid.intersections(coordinates))
          .to eq(grid.row(coordinates) + grid.column(coordinates) + grid.group_for(coordinates))
      end
    end
  end
end
