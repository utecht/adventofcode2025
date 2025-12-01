#!/usr/bin/env ruby

require_relative "../lib/aoc/core"

example_path = File.join(__dir__, "day01.example")
example_lines = Aoc::Input.lines(example_path)

input_path = File.join(__dir__, "day01.input")
lines = Aoc::Input.lines(input_path)

def part1(lines)
  current_dial = 50
  password = 0
  lines.each do |line|
    dir = line[0]
    steps = line[1..].to_i
    case dir
    when 'R'
      current_dial = (current_dial + steps) % 100
    when 'L'
      current_dial = (current_dial - steps) % 100
      current_dial = 100 + current_dial if current_dial < 0
    end
    password += 1 if current_dial == 0
    #puts "#{line.strip} - #{current_dial}"
  end
  password
end

def part2(lines)
  current_dial = 50
  password = 0
  lines.each do |line|
    dir = line[0]
    steps = line[1..].to_i
    case dir
    when 'R'
      steps.times do
        current_dial += 1
        current_dial %= 100
        password += 1 if current_dial == 0
      end
    when 'L'
      steps.times do
        current_dial -= 1
        current_dial = 99 if current_dial < 0
        password += 1 if current_dial == 0
      end
    end
  end
  password
end

if true
  puts "Part 1 Example: #{part1(example_lines)}"
  puts "Part 2 Example: #{part2(example_lines)}"
end

if true
  puts "Part 1: #{part1(lines)}"
  puts "Part 2: #{part2(lines)}"
end
