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

    def row(row_index)
      row_start_index = row_index * SIZE
      row_end_index = row_start_index + SIZE - 1
      values[row_start_index..row_end_index]
    end
  end
end
