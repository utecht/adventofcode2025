#!/usr/bin/env ruby

require_relative "../lib/aoc/core"

example_path = File.join(__dir__, "day03.example")
example_lines = Aoc::Input.ints_array(example_path)

input_path = File.join(__dir__, "day03.input")
lines = Aoc::Input.ints_array(input_path)

def part1(lines)
  sum = 0
  lines.each do |line|
    first_num = line[...-1].max
    index = line.index(first_num) + 1
    second_num = line[index..].max
    sum += "#{first_num}#{second_num}".to_i
  end
  sum
end

def part2(lines)
  sum = 0
  lines.each do |line|
    num = Array.new
    index = 0
    12.times do |t|
      end_index = line[index..].length - (12 - t) + index
      largest = line[index..end_index].max
      index = line[index..end_index].index(largest) + index + 1
      num << largest
    end
    sum += num.join('').to_i
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
