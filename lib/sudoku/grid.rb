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
          yield(value, row_index, column_index)
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

    def [](x, y)
      values[x*SIZE + y]
    end

    def rows
      (0...SIZE).map { |row_index| row(row_index) }
    end

    def column(column_index)
      (0...SIZE).map { |row_index| self[row_index, column_index] }
    end

    def self.row_range(row_index)
      row_start_index = row_index * SIZE
      row_end_index = row_start_index + SIZE - 1

      row_start_index..row_end_index
    end

    def row(row_index)
      values[self.class.row_range(row_index)]
    end


    def group_for(row_index, column_index)
      rows[self.class.index_to_group_range(row_index)]
        .map { |row| row[self.class.index_to_group_range(column_index)] }
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
  end
end
