#!/usr/bin/env ruby

require_relative "../lib/aoc/core"

example_path = File.join(__dir__, "day02.example")
example_lines = Aoc::Input.raw(example_path)

input_path = File.join(__dir__, "day02.input")
lines = Aoc::Input.raw(input_path)

def part1(lines)
  sum = 0
  lines.split(',').each do |range|
    first_id, second_id = range.split('-').map(&:to_i)
    (first_id..second_id).each do |id|
      id = id.to_s
      l = id.length
      if l % 2 == 0
        hl = l / 2
        if id[0,hl] == id[hl..]
          sum += id.to_i
        end
      end
    end
  end
  sum
end

def part2(lines)
  sum = 0
  invalid_ids = Set.new
  lines.split(',').each do |range|
    first_id, second_id = range.split('-').map(&:to_i)
    (first_id..second_id).each do |id|
      id = id.to_s
      id_length = id.length
      half_length = id_length / 2
      half_length.times do |i|
        i += 1
        next unless id_length % i == 0
        id_arr = id.chars
        test_section = id_arr.shift(i)
        good = true
        until id_arr.empty?
          next_section = id_arr.shift(i)
          good = false unless test_section.to_s == next_section.to_s
        end
        if good
          sum += id.to_i unless invalid_ids.include?(id)
          invalid_ids.add(id)
        end
      end
    end
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
