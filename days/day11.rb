#!/usr/bin/env ruby

require_relative "../lib/aoc/core"

example_path = File.join(__dir__, "day11.example")
example_lines = Aoc::Input.lines(example_path)

input_path = File.join(__dir__, "day11.input")
lines = Aoc::Input.lines(input_path)

$cache = Hash.new(0)

def follow_path(graph, node, current_path)
  return 1 if node == 'out'
  return 0 if current_path.include?(node)
  sum = 0
  new_path = current_path.dup
  new_path << node
  graph[node].each do |next_node|
    sum += follow_path(graph, next_node, new_path)
  end
  sum
end

def follow_path_2(graph, node, current_path, target)
  return 1 if node == target
  return 0 if node == 'out'
  sum = 0
  new_path = current_path.dup
  new_path << node
  graph[node].each do |next_node|
    # this is a known good path
    if $cache.include?([node, next_node])
      sum += $cache[[node, next_node]]
    else
      ret = follow_path_2(graph, next_node, new_path, target)
      #puts "Caching Value #{node} -> #{next_node} = #{sum}" if ret > 0
      $cache[[node, next_node]] = ret
      sum += ret
    end
  end
  sum
end


def part1(lines)
  graph = Hash.new
  lines.each do |line|
    node, connections = line.match(/(.+): (.+)/).captures
    graph[node] = connections.split(' ')
  end
  follow_path(graph, 'you', [])
end

def part2(lines)
  graph = Hash.new
  lines.each do |line|
    node, connections = line.match(/(.+): (.+)/).captures
    graph[node] = connections.split(' ')
  end
  $cache = Hash.new(0)
  svr_fft = follow_path_2(graph, 'svr', [], 'fft')
  $cache = Hash.new(0)
  svr_dac = follow_path_2(graph, 'svr', [], 'dac')
  $cache = Hash.new(0)
  dac_fft = follow_path_2(graph, 'dac', [], 'fft')
  $cache = Hash.new(0)
  fft_dac = follow_path_2(graph, 'fft', [], 'dac')
  $cache = Hash.new(0)
  fft_out = follow_path_2(graph, 'fft', [], 'out')
  $cache = Hash.new(0)
  dac_out = follow_path_2(graph, 'dac', [], 'out')

  puts "svr_fft #{svr_fft} | svr_dac #{svr_dac} | fft_dac #{fft_dac} | dac_fft #{dac_fft} | dac_out #{dac_out} | fft_out #{fft_out}"
  (svr_fft * fft_dac * dac_out) + (svr_dac * dac_fft * fft_out)
end

if true
  #puts "Part 1 Example: #{part1(example_lines)}"
  puts "Part 2 Example: #{part2(example_lines)}"
end

if true
  #puts "Part 1: #{part1(lines)}"
  puts "Part 2: #{part2(lines)}"
end
