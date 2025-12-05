module Aoc
  module Progress
    module_function

    def each_with_progress(enum, every: 100)
      total = enum.size rescue nil
      i = 0

      enum.each do |elem|
        yield elem

        i += 1
        if (i % every).zero?
          if total
            pct = (i * 100.0 / total).round(2)
            puts "[#{i}/#{total}] (#{pct}%)"
          else
            puts "[#{i}]"
          end
        end
      end
    end
  end
end
