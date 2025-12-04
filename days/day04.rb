#!/usr/bin/env ruby

require_relative "../lib/aoc/core"

example_path = File.join(__dir__, "day04.example")
example_lines = Aoc::Input.lines(example_path)

input_path = File.join(__dir__, "day04.input")
lines = Aoc::Input.lines(input_path)

def part1(lines)
  sum = 0
  grid = Aoc::Grid.new(lines)
  grid.height.times do |y|
    grid.width.times do |x|
      neighbors = grid.neighbors8(y,x).inspect
      is_paper = grid[y, x] == '@'
      paper = neighbors.count('@')
      sum += 1 if paper < 4 && is_paper
      if paper < 4 && is_paper
        print 'x'
      else
        print grid[y, x]
      end
    end
    puts ''
  end
  puts '\n'
  sum
end

def part2(lines)
  sum = 0
  last_sum = -1 
  grid = Aoc::Grid.new(lines)
  until sum == last_sum
    last_sum = sum
    new_grid = grid.clone
    grid.height.times do |y|
      grid.width.times do |x|
        neighbors = grid.neighbors8(y,x).inspect
        is_paper = grid[y, x] == '@'
        paper = neighbors.count('@')
        if paper < 4 && is_paper
          new_grid[y,x] = '.'
          sum += 1
          print 'x'
        else
          print grid[y, x]
        end
      end
      puts ''
    end
    puts '\n'
    grid = new_grid.clone
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
