#!/usr/bin/env ruby

require_relative "../lib/aoc/core"

example_path = File.join(__dir__, "day12.example")
example_lines = Aoc::Input.lines(example_path)

input_path = File.join(__dir__, "day12.input")
lines = Aoc::Input.lines(input_path)

def part1(lines)
  shapes = []
  6.times do |n|
    lines.shift
    area = lines.shift.count("#")
    area += lines.shift.count("#")
    area += lines.shift.count("#")
    lines.shift
    shapes << area
  end
  fits = 0
  lines.each do |line|
    target, boxes = line.split(":")
    x, y = target.split('x').map(&:to_i)
    boxes = boxes.chomp.strip.split(' ').map(&:to_i)
    target_area = x * y
    box_area = 0
    boxes.each_with_index do |n, i|
      box_area += shapes[i] * n
    end
    fits += 1 if box_area <= target_area
  end
  fits
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
