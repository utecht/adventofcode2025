#!/usr/bin/env ruby

require_relative "../lib/aoc/core"
require "parallel"

example_path = File.join(__dir__, "day10.example")
example_lines = Aoc::Input.lines(example_path)

input_path = File.join(__dir__, "day10.input")
lines = Aoc::Input.lines(input_path)

def press(state, button)
  ret = state.clone
  ret.length.times do |i|
    ret[i] = !ret[i] if button.include?(i)
  end
  ret
end

def count_iterations(target, buttons)
  target = target.chars.map { |s| s == '#' }
  iterations = 0
  states = [target]
  loop do
    return 0 if states.empty?
    iterations += 1
    new_states = Array.new
    states.each do |state|
      state.each_with_index do |b, n|
        next unless b
        buttons.each do |button|
          if button.include?(n)
            new_state = press(state, button)
            return iterations unless new_state.include?(true)
            new_states << new_state
          end
        end
      end
    end
    states = new_states
  end
end

def part1(lines)
  sum = 0
  i = 0
  lines.each do |line|
    target, buttons, joltage = line.match(/\[(.+)\] (.+) \{(.+)}/).captures
    buttons = buttons.gsub(/[()]/, '').split.map do |s|
      s.split(',').map(&:to_i)
    end
    sum += count_iterations(target, buttons)
    puts "sum found #{sum} i: #{i}"
    i += 1
  end
  sum
end

def press_jolt(state, button, buffer)
  state.each_with_index do |n, i|
    buffer[i] = n
  end
  button.each do |n|
    buffer[n] -= 1
    return nil if buffer[n] < 0
  end
  buffer
end

def count_joltage(joltage, buttons)
  iterations = 0
  states = Set.new
  states.add(joltage.dup)
  new_states = Set.new
  buffer = Array.new(joltage.length, 0)
  loop do
    return 0 if states.count == 0
    iterations += 1
    puts "i: #{iterations} states: #{states.count} e.g. #{states.first.inspect}" if iterations % 10 == 0
    new_states.clear
    states.each do |state|
      buttons.each do |button|
        next_state = press_jolt(state, button, buffer)
        next if next_state.nil?
        new_state = next_state.dup
        return iterations if new_state.sum == 0
        new_states.add(new_state)
      end
    end
    states, new_states = new_states, states
  end
end

def part2(lines)
  sum = 0
  i = 0
  inputs = Array.new
  lines.each do |line|
    target, buttons, joltage = line.match(/\[(.+)\] (.+) \{(.+)}/).captures
    buttons = buttons.gsub(/[()]/, '').split.map do |s|
      s.split(',').map(&:to_i)
    end
    joltage = joltage.chomp.split(',').map(&:to_i)
    inputs << [joltage, buttons]
  end

  results = Parallel.map(inputs, in_processes: 12) do |joltage, buttons|
    count_joltage(joltage, buttons)
  end

  results.sum
end

if true
  puts "Part 1 Example: #{part1(example_lines)}"
  puts "Part 2 Example: #{part2(example_lines)}"
end

if true
  # puts "Part 1: #{part1(lines)}"
  puts "Part 2: #{part2(lines)}"
end
