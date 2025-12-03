module Aoc
  module Input
    module_function

    def lines(path)
      File.read(path, chomp: true).lines
    end

    def ints(path)
      lines(path).map { |l| l.to_i }
    end

    def ints_array(path)
      lines(path).map { |l| l.strip.chars.map(&:to_i) }
    end

    def raw(path)
      File.read(path, chomp: true)
    end
  end
end
