require 'sudoku/coordinates'

module Sudoku
  RSpec.describe Coordinates do
    describe "#row" do
      it "returns row values when called without arguments" do
        expect(Coordinates.new(1, 2).row).to eq(1)
      end

      it "returns new instance with passed in row" do
        expect(Coordinates.new(1, 2).row(3)).to eq(Coordinates.new(3, 2))
      end
    end

    describe "#col" do
      it "returns col values when called without arguments" do
        expect(Coordinates.new(1, 2).col).to eq(2)
      end

      it "returns new instance with passed in col" do
        expect(Coordinates.new(1, 2).col(3)).to eq(Coordinates.new(1, 3))
      end
    end
  end
end
