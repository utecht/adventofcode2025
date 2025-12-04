module Aoc
  class Grid
    attr_reader :rows, :width, :height

    def initialize(lines)
      @rows   = lines.map { |l| l.chomp.chars }
      @height = @rows.size
      @width  = @rows.first&.size || 0
    end

    def [](y, x)
      return nil if y < 0 || x < 0 || y >= height || x >= width
      @rows[y][x]
    end

    def []=(y,x,value)
      return nil if y < 0 || x < 0 || y >= height || x >= width
      @rows[y][x] = value
    end

    def neighbors4(y, x)
      [[y - 1, x], [y + 1, x], [y, x - 1], [y, x + 1]]
        .select { |ny, nx| ny.between?(0, height - 1) && nx.between?(0, width - 1) }
    end

    def neighbors8(y, x)
      [
        self[y - 1, x - 1], self[y - 1, x], self[y - 1, x  + 1],
        self[y, x - 1],                     self[y, x  + 1],
        self[y + 1, x - 1], self[y + 1, x], self[y + 1, x  + 1],

      ]
    end
  end
end
