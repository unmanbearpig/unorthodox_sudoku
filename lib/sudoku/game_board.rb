require 'set'

module Sudoku
  class GameBoard
    SIZE = 9.freeze

    attr_reader :values
    def initialize(*board_values)
      if board_values.size != SIZE*SIZE
        raise ArgumentError.new("Invalid board size #{board_values.size}, expected #{SIZE}x#{SIZE} = #{SIZE*SIZE}")
      end

      @values = board_values
    end

    def map(&block)
      new_values = rows.each_with_index.flat_map do |row, row_index|
        row.each_with_index.map do |value, column_index|
          yield(value, row_index, column_index)
        end
      end

      GameBoard.new(*new_values)
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

    def rows
      (0...SIZE).map { |row_index| row(row_index) }
    end

    def column(column_index)
      (0...SIZE).map { |row_index| self[row_index, column_index] }
    end

    def possible_values
      all_values = Set.new(1..9)

      map do |value, row_index, column_index|
        if value == 0
          row_values = Set.new(row(row_index)) - Set.new([0])
          column_values = Set.new(column(column_index)) - Set.new([0])

          all_values - row_values - column_values
        else
          Set.new([value])
        end
      end
    end
  end
end
