require 'sudoku/coordinates'

module Sudoku
  class Grid
    SIZE = 9.freeze
    DIMENSION = (0...SIZE).freeze

    class ValueWithCoordinates < Struct.new(:value, :coordinates)
      def to_s
        "<#{value.inspect} at #{coordinates}>"
      end
      alias_method :inspect, :to_s
    end

    include Enumerable

    attr_reader :values

    def initialize(values)
      if values.size != SIZE*SIZE
        raise ArgumentError.new("Invalid grid size #{values.size}, expected #{SIZE}x#{SIZE} = #{SIZE*SIZE}")
      end

      @values = values.freeze
    end

    def set(coordinates, new_value)
      self.class.new(values.dup.tap { |v| v[coordinates.absolute_index] = new_value })
    end

    def each(&block)
      new_values = rows.each_with_index.flat_map do |row, row_index|
        row.each_with_index.map do |value, column_index|
          yield(value, Coordinates.new(row_index, column_index))
        end
      end
    end

    def with_coordinates
      map { |value, coordinates| ValueWithCoordinates.new(value, coordinates) }.to_a
    end

    def grid
      self
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
      values[coordinates.absolute_index]
    end

    def rows
      @rows ||= DIMENSION.map { |row_index| values[self.class.row_range(row_index)] }.freeze
    end

    def column(coordinates)
      DIMENSION.map { |row_index| self[coordinates.row(row_index)] }
    end

    def columns
      @columns ||= rows.transpose
    end

    def groups
      @groups ||= (0..2).flat_map do |x|
        (0..2).map do |y|
          group_by_id(x, y)
        end
      end.freeze
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
      group_by_id(coordinates.group_row,
                  coordinates.group_col)
    end

    def group_by_id(x, y)
      rows[self.class.group_index_to_group_range(x)]
        .flat_map { |row| row[self.class.group_index_to_group_range(y)] }
    end

    def domains
      rows + columns + groups
    end

    def self.group_index_to_group_range(index)
      case index
      when 0 then 0..2
      when 1 then 3..5
      when 2 then 6..8
      else
        raise ArgumentError.new("group index #{index} is out of range")
      end
    end

    def intersections(coordinates)
      row(coordinates) + column(coordinates) + group_for(coordinates)
    end

    def to_s
      "\n" + '-'*9 + "\n" +
        rows.map do |row|
        row.map(&:to_s).join(" ")
      end.join("\n") + "\n" + '-'*9 + "\n"

    end
    alias_method :inspect, :to_s
  end
end
