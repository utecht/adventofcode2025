#!/usr/bin/env ruby

require_relative "../lib/aoc/core"

example_path = File.join(__dir__, "day07.example")
example_lines = Aoc::Input.lines(example_path)
example_grid = Aoc::Grid.new(example_lines)

input_path = File.join(__dir__, "day07.input")
lines = Aoc::Input.lines(input_path)
full_grid = Aoc::Grid.new(lines)

def part1(grid)
  beams = Set.new
  split_count = 0
  grid.rows.each do |row|
    row.each_with_index do |r, i|
      if beams.include?(i) && r == '^'
        beams.delete(i)
        beams.add(i - 1) if i > 0
        beams.add(i + 1) if i < grid.width
        split_count += 1
      end
      if r == 'S'
        beams.add(i)
      end
    end
  end
  split_count
end

def track_beam(row, beam_i, grid)
  beam_count = 0
  grid.rows[row].each_with_index do |r, i|
    if beam_i == i && r == '^'
      beam_count += 1
      beam_count += track_beam(row, i - 1, grid) if i > 0
      beam_count += track_beam(row, i + 1, grid) if i < grid.width
    elsif beam_i == i
      beam_count += track_beam(row + 1, i, grid) if row + 1 < grid.height
    end
  end
  beam_count
end

def part2_old(grid)
  starting_s = grid.rows[0].index('S')
  track_beam(1, starting_s, grid) + 1
end

def part2(grid)
  beams = Array.new(grid.width, 0)
  split_count = 0
  grid.rows.each do |row|
    row.each_with_index do |r, i|
      if beams[i] > 0 && r == '^'
        count = beams[i]
        beams[i - 1] += count if i > 0
        beams[i + 1] += count if i < grid.width
        beams[i] = 0
        split_count += count
      end
      if r == 'S'
        beams[i] = 1
      end
    end
  end
  split_count + 1
end

if true
  puts "Part 1 Example: #{part1(example_grid)}"
  puts "Part 2 Example: #{part2(example_grid)}"
end

if true
  puts "Part 1: #{part1(full_grid)}"
  puts "Part 2: #{part2(full_grid)}"
end
