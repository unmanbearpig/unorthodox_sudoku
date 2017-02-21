module Sudoku
  class GameBoard
    attr_reader :values
    def initialize(*board_values)
      @values = board_values
    end

    def ==(other)
      values == other.values
    end
  end
end
