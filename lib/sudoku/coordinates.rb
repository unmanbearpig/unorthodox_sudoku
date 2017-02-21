module Sudoku
  class Coordinates
    def initialize(row, col)
      @row = row
      @col = col
    end

    def ==(other)
      row == other.row && col == other.col
    end

    def row(new_row = :no_arg)
      return @row if new_row == :no_arg

      self.class.new(new_row, col)

    end

    def col(new_col = :no_arg)
      return @col if new_col == :no_arg

      self.class.new(row, new_col)
    end

    def self.row(row_index)
      new(row_index, nil)
    end

    def self.col(column_index)
      new(nil, column_index)
    end

    def to_s
      "(#{row || '_'}x#{col || '_'})"
    end
    alias_method :inspect, :to_s
  end
end
