require 'sudoku/coordinates'

module Sudoku
  class Grid
    include Enumerable

    SIZE = 9.freeze

    attr_reader :values, :SIZE

    def initialize(values)
      if values.size != SIZE*SIZE
        raise ArgumentError.new("Invalid grid size #{values.size}, expected #{SIZE}x#{SIZE} = #{SIZE*SIZE}")
      end

      @values = values
    end

    def each(&block)
      new_values = rows.each_with_index.flat_map do |row, row_index|
        row.each_with_index.map do |value, column_index|
          yield(value, Coordinates.new(row_index, column_index))
        end
      end
    end

    def map(&block)
      self.class.new(super(&block))
    end

    def to_a
      values.to_a
    end

    def ==(other)
      values == other.values
    end

    def [](coordinates)
      values[coordinates.row * SIZE + coordinates.col]
    end

    def rows
      (0...SIZE).map { |row_index| row(Coordinates.new(row_index, nil)) }
    end

    def column(coordinates)
      (0...SIZE).map { |row_index| self[coordinates.row(row_index)] }
    end

    def self.row_range(row_index)
      row_start_index = row_index * SIZE
      row_end_index = row_start_index + SIZE - 1

      row_start_index..row_end_index
    end

    def row(coordinates)
      values[self.class.row_range(coordinates.row)]
    end

    def group_for(coordinates)
      rows[self.class.index_to_group_range(coordinates.row)]
        .map { |row| row[self.class.index_to_group_range(coordinates.col)] }
        .flatten
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

    def self.index_to_group_range(index)
      case index_to_group_index(index)
      when 0 then 0..2
      when 1 then 3..5
      when 2 then 6..8
      end
    end

    def intersections(coordinates)
      row(coordinates) + column(coordinates) + group_for(coordinates)
    end
  end
end
