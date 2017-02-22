module Sudoku
  class Coordinates
    SIZE = 9.freeze

    def initialize(row, col)
      @row = row
      @col = col
    end

    def to_a
      [row, col]
    end

    def absolute_index
      row * SIZE + col
    end

    def group_row
      self.class.index_to_group_index(row)
    end

    def group_col
      self.class.index_to_group_index(col)
    end

    def self.index_to_group_index(index)
      if index < 3
        0
      elsif index < 6
        1
      elsif index < 9
        2
      else
        raise ArgumentError.new("Invalid index #{index}, expected 0..8")
      end
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

  class ValueWithCoordinates < Delegator
    attr_reader :value, :coordinates
    def initialize(value, coordinates)
      @value = value
      @coordinates = coordinates
    end

    def __getobj__
      value
    end

    def to_s
      "<#{value.inspect} at #{coordinates}>"
    end
    alias_method :inspect, :to_s
  end
end
