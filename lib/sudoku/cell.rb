module Sudoku
  class Cell < ValueWithCoordinates
    def initialize(*args)
      super
      unless value.kind_of?(Set)
        @value = Set[value]
      end
    end

    def known?
      @known ||= value.size == 1
    end

    def to_i
      known? ? first : 0
    end

    def inspect
      "<[#{to_a.join('|')}] at #{coordinates} >"
    end
  end
end
