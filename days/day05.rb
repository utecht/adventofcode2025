#!/usr/bin/env ruby

require_relative "../lib/aoc/core"

example_path = File.join(__dir__, "day05.example")
example_lines = Aoc::Input.lines(example_path)

input_path = File.join(__dir__, "day05.input")
lines = Aoc::Input.lines(input_path)

def part1(lines)
  ranges = Array.new
  sum = 0
  adding_ranges = true
  lines.each do |line|
    if line.strip == ''
      adding_ranges = false
      next
    end
    if adding_ranges
      low, high = line.split('-').map(&:to_i)
      ranges << [low, high]
    else
      ingredient_id = line.to_i
      ranges.each do |range|
        if ingredient_id >= range[0] && ingredient_id <= range[1]
          sum += 1
          break
        end
      end
    end
  end
  sum
end

def part2(lines)
  ranges = Array.new
  lines.each do |line|
    if line.strip == ''
      break
    end
    low, high = line.split('-').map(&:to_i)
    ranges << [low, high]
  end
  ranges.sort! { |x,y| x[0] <=> y[0] }

  skip = true
  prev_high = 0
  new_ranges = Array.new
  ranges.each do |low, high|
    if skip
      skip = false
      prev_high = high
      new_ranges << [low, high]
      next
    end
    if low <= prev_high
      low = prev_high + 1
    end
    if low <= high
      new_ranges << [low, high]
    end
    prev_high = high if high > prev_high
  end
  sum = 0
  new_ranges.each do |low, high|
    sum += (high - low) + 1
  end
  sum
end

if true
  puts "Part 1 Example: #{part1(example_lines)}"
  puts "Part 2 Example: #{part2(example_lines)}"
end

if true
  puts "Part 1: #{part1(lines)}"
  puts "Part 2: #{part2(lines)}"
end
