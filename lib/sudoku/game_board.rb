module Sudoku
  class GameBoard
    SIZE = 9.freeze

    attr_reader :values
    def initialize(*board_values)
      @values = board_values
    end

    def ==(other)
      values == other.values
    end

    def [](x, y)
      values[x*SIZE + y]
    end
  end
end
