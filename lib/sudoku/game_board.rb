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

    def self.row_range(row_index)
      row_start_index = row_index * SIZE
      row_end_index = row_start_index + SIZE - 1

      row_start_index..row_end_index
    end

    def row(row_index)
      values[self.class.row_range(row_index)]
    end

    def column(column_index)
      (0...SIZE).map { |row_index| self[row_index, column_index] }
    end
  end
end
