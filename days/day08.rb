#!/usr/bin/env ruby

require_relative "../lib/aoc/core"

example_path = File.join(__dir__, "day08.example")
example_lines = Aoc::Input.lines(example_path)

input_path = File.join(__dir__, "day08.input")
lines = Aoc::Input.lines(input_path)

def distance(q, p)
  Math.sqrt(((q[0] - p[0]) ** 2) + ((q[1] - p[1]) ** 2) + ((q[2] - p[2]) ** 2))
end

def part1(lines, num)
  points = Array.new
  lines.each do |line|
    points << line.chomp.split(',').map(&:to_i)
  end
  ppoints = points.product(points)
  ppoints.each do |ps|
    ps.prepend(distance(ps[0], ps[1]))
  end
  ppoints.reject! { |p| p[0] == 0.0 }
  ppoints.sort! { |a,b| a[0] <=> b[0] }
  ppoints.reverse!
  circuits = Array.new
  num.times do |i|
    d, a, b = ppoints.pop
    ppoints.pop.inspect
    as = "#{a[0]},#{a[1]},#{a[2]}"
    bs = "#{b[0]},#{b[1]},#{b[2]}"
    added = false
    circuits.each do |cs|
      if cs.include?(as) || cs.include?(bs)
        cs.add(as)
        cs.add(bs)
        added = true
      end
    end
    unless added
      set = Set.new
      set.add(as)
      set.add(bs)
      circuits << set
    end
  end
  starting_count = 0
  until circuits.length == starting_count
    starting_count = circuits.count
    merged_circuits = Array.new
    circuits.each do |circuit|
      merged = false
      merged_circuits.each do |mc|
        if mc.intersect?(circuit)
          merged = true
          mc.merge(circuit)
        end
      end
      unless merged
        merged_circuits << circuit
      end
    end
    circuits = merged_circuits
  end
  circuits.sort! { |a,b| b.count <=> a.count }
  puts circuits.map(&:count).inspect
  circuits[0].count * circuits[1].count * circuits[2].count
end

def merge_down(circuits)
  starting_count = 0
  until circuits.length == starting_count
    starting_count = circuits.count
    merged_circuits = Array.new
    circuits.each do |circuit|
      merged = false
      merged_circuits.each do |mc|
        if mc.intersect?(circuit)
          merged = true
          mc.merge(circuit)
          break
        end
      end
      unless merged
        merged_circuits << circuit
      end
    end
    circuits = merged_circuits
  end
  circuits
end

def part2(lines)
  points = Array.new
  lines.each do |line|
    points << line.chomp.split(',').map(&:to_i)
  end
  ppoints = points.product(points)
  ppoints.each do |ps|
    ps.prepend(distance(ps[0], ps[1]))
  end
  ppoints.reject! { |p| p[0] == 0.0 }
  ppoints.sort! { |a,b| a[0] <=> b[0] }
  ppoints.reverse!
  circuits = Array.new
  last_x1 = 0
  last_x2 = 0
  junction_box_count = lines.length
  done = false
  until done 
    d, a, b = ppoints.pop
    as = "#{a[0]},#{a[1]},#{a[2]}"
    bs = "#{b[0]},#{b[1]},#{b[2]}"
    last_x1 = a[0]
    last_x2 = b[0]
    added = false
    circuits.each do |cs|
      if cs.include?(as) || cs.include?(bs)
        cs.add(as)
        cs.add(bs)
        added = true
      end
    end
    unless added
      set = Set.new
      set.add(as)
      set.add(bs)
      circuits << set
    end
    #ppoints.reject! { |p| p[0] == a || p[1] == b }
    circuits = merge_down(circuits)
    puts circuits.length
    done = circuits[0].count == junction_box_count
  end
  last_x1 * last_x2
end

if true
  puts "Part 1 Example: #{part1(example_lines, 10)}"
  puts "Part 2 Example: #{part2(example_lines)}"
end

if true
  puts "Part 1: #{part1(lines, 1000)}"
  puts "Part 2: #{part2(lines)}"
end
