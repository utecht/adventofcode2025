#!/usr/bin/env ruby

require_relative "../lib/aoc/core"

example_path = File.join(__dir__, "day06.example")
example_lines = Aoc::Input.lines(example_path)

input_path = File.join(__dir__, "day06.input")
lines = Aoc::Input.lines(input_path)

def part1(lines)
  operands = lines.pop.strip.split.map(&:chomp)
  columns = Array.new(operands.count) { Array.new }
  lines.each do |line|
    line.strip.split.map(&:chomp).map(&:to_i).each_with_index do |n, i|
      columns[i] << n
    end
  end
  sum = 0
  operands.each_with_index do |op, i|
    case op
    when '+'
      sum += columns[i].inject(:+)
    when '*'
      sum += columns[i].inject(:*)
    end
  end
  sum
end

def part2(lines)
  sum = 0
  lines = lines.map(&:chomp).map(&:reverse)
  nums = Array.new
  working_num = ''
  lines[0].length.times do |i|
    lines.each do |line|
      char = line[i]
      case char
      when '+'
        working_num.strip!
        unless working_num == ''
          nums << working_num.to_i
        end
        working_num = ''
        sum += nums.inject(:+)
        nums = Array.new
      when '*'
        working_num.strip!
        unless working_num == ''
          nums << working_num.to_i
        end
        working_num = ''
        sum += nums.inject(:*)
        nums = Array.new
      when ' '
        working_num.strip!
        unless working_num == ''
          nums << working_num.to_i
        end
        working_num = ''
      else
        working_num << char
      end
    end
  end
  sum
end

if true
  #puts "Part 1 Example: #{part1(example_lines)}"
  puts "Part 2 Example: #{part2(example_lines)}"
end

if true
  #puts "Part 1: #{part1(lines)}"
  puts "Part 2: #{part2(lines)}"
end
