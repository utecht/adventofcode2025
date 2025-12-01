#!/usr/bin/env ruby

require_relative "../lib/aoc/core"

example_path = File.join(__dir__, "dayXX.example")
example_lines = Aoc::Input.lines(example_path)

input_path = File.join(__dir__, "dayXX.input")
lines = Aoc::Input.lines(input_path)

def part1(lines)
end

def part2(lines)
end

if true
  puts "Part 1 Example: #{part1(example_lines)}"
  puts "Part 2 Example: #{part2(example_lines)}"
end

if true
  puts "Part 1: #{part1(lines)}"
  puts "Part 2: #{part2(lines)}"
end
