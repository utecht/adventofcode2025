#!/usr/bin/env ruby

require_relative "../lib/aoc/core"

example_path = File.join(__dir__, "day09.example")
example_lines = Aoc::Input.lines(example_path)

input_path = File.join(__dir__, "day09.input")
lines = Aoc::Input.lines(input_path)

$debug = false

def part1(lines)
  points = Array.new
  lines.each do |line|
    points << line.chomp.split(',').map(&:to_i)
  end
  
  ppoints = points.product(points)
  max_area = 0
  ppoints.each do |pp|
    ax, ay = pp[0]
    bx, by = pp[1]

    area = ((ax - bx + 1) * (ay - by + 1))
    max_area = area if area > max_area
  end
  max_area
end

def inside_rect(x, y, xmin, xmax, ymin, ymax)
  (xmin < x && x < xmax) && (ymin < y && y < ymax)
end

def cross(ax, ay, bx, by)
  (ax * by) - (ay * bx)
end

# returns positive or negative
def orient(ax, ay, bx, by, cx, cy)
  cax = bx - ax
  cay = by - ay
  cbx = cx - ax
  cby = cy - ay
  cross(cax, cay, cbx, cby)
end

def intersects(ax, ay, bx, by, cx, cy, dx, dy)
  oabc = orient(ax, ay, bx, by, cx, cy)
  oabd = orient(ax, ay, bx, by, dx, dy)

  ocda = orient(cx, cy, dx, dy, ax, ay)
  ocdb = orient(cx, cy, dx, dy, bx, by)

  # if ABC & ABD have opposite signs and CDA & CDB have opposite signs
  (oabc * oabd < 0 && ocda * ocdb < 0)
end

def on_segment(ax, ay, bx, by, px, py)
  orient(ax, ay, bx, by, px, py).zero? &&
    px.between?([ax, bx].min, [ax, bx].max) &&
    py.between?([ay, by].min, [ay, by].max)
end

def point_in_polygon(px, py, points)
  max_x = points.map{ |x, y| x }.max
  ray_end_x = [max_x, px].max + 1

  intersections = 0
  lx, ly = points.last
  points.each do |point|
    x, y = point

    # first check if any of the corners are on the line segment
    return true if on_segment(x, y, lx, ly, px, py)
    # ray cast to intersect test
    puts "intersects?(edge: (#{x}, #{y}) -> (#{lx}, #{ly}), ray: (#{px}, #{py}) -> (#{px + ray_end_x}, #{py}))" if $debug
    #intersections += 1 if intersects(x, y, lx, ly, px, py, px + HEIGHT, py)
    intersections += 1 if intersects(x, y, lx, ly, px, py, px + ray_end_x, py)

    lx, ly = point
  end
  intersections % 2 == 1
end

def corners_inside_polygon(xmin, xmax, ymin, ymax, points)
  # first check if any of the corners are on the line segment
  return false unless point_in_polygon(xmin, ymin, points)
  return false unless point_in_polygon(xmin, ymax, points)
  return false unless point_in_polygon(xmax, ymin, points)
  return false unless point_in_polygon(xmax, ymax, points)
  true
end

def is_contained(points, rect)
  ax, ay = rect[0]
  bx, by = rect[1]
  xmin, xmax = [ax, bx].sort
  ymin, ymax = [ay, by].sort

  last_point = points.last
  points.each do |point|
    x, y = point
    # if a point is fully inside the rectangle it is not valid
    #puts "#{x},#{y} inside #{[xmin,ymin,xmax,ymax]}" if inside_rect(x, y, xmin, xmax, ymin, ymax)
    return false if inside_rect(x, y, xmin, xmax, ymin, ymax)
    # if any line intersects with the outside of the rectangle it is not valid
    #puts "#{x},#{y} <-> #{last_point[0]},#{last_point[1]} intersects #{[xmin,ymin,xmax,ymax]}" if intersects(ax, ay, bx, by, x, y, last_point[0], last_point[1])
    return false if intersects(ax, ay, bx, by, x, y, last_point[0], last_point[1])
    last_point = point
  end
  # if any points fall outside the polygon also external
  return false unless corners_inside_polygon(xmin, xmax, ymin, ymax, points)
  true
end

def write_ppm(grid, width, height)

  maxval = 255

  File.open('debug09.ppm', 'wb') do |f|
    f.puts "P6"
    f.puts "#{width} #{height}"
    f.puts maxval

    height.times do |y|
      width.times do |x|
        val = grid[(y * width) + x]
        r, g, b = [0, 0, 0]
        r = 255 if val >= 2
        b = 150 if val.to_i != val
        g = 255 if val == 1 || val == 1.5
        f.write [r, g, b].pack('C3')
      end
    end
  end
end

def debug_drawing(points, max_rect)
  max_x = 0
  max_y = 0
  points.each do |p|
    max_x = p[0] if p[0] > max_x
    max_y = p[1] if p[1] > max_y
  end

  max_x += 2
  max_y += 2

  width = max_x
  height = max_y

  grid = Array.new(height * width, 0)

  # first draw rect
  ax, ay = max_rect[0]
  bx, by = max_rect[1]
  min_x, max_x = [ax, bx].sort
  min_y, max_y = [ay, by].sort

  (min_x..max_x).each do |x|
    (min_y..max_y).each do |y|
      grid[(y * width) + x] += 0.5
    end
  end

  # second draw lines
  bx, by = points.last
  points.each do |point|
    ax, ay = point

    min_x, max_x = [ax, bx].sort
    min_y, max_y = [ay, by].sort

    # vertical line
    if min_x == max_x 
      (min_y..max_y).each do |y|
        grid[(y * width) + min_x] += 1
      end
    else
      (min_x..max_x).each do |x|
        grid[(min_y * width) + x] += 1
      end
    end

    bx, by = point
  end

  # draw points
  #points.each do |point|
  #  x, y = point
  #  grid[y][x] += 1
  #end

  write_ppm(grid, width, height)
end

def part2(lines)
  points = Array.new
  lines.each do |line|
    points << line.chomp.split(',').map(&:to_i)
  end

  ppoints = points.product(points)
  max_area = 0
  max_rect = []
  ppoints.each do |pp|
    ax, ay = pp[0]
    bx, by = pp[1]
    $debug = (ax == 11 && ay == 1 && bx == 6 && by == 9)
    puts "DEBUGGING NOW" if $debug

    min_x, max_x = [ax, bx].sort
    min_y, max_y = [ay, by].sort
    area = ((max_x - min_x + 1) * (max_y - min_y + 1))
    puts "AREA #{area} max area #{max_area}" if $debug
    if area > max_area && is_contained(points, pp)
      max_area = area 
      max_rect = pp
    end
  end
  #debug_drawing(points, max_rect)
  max_area
end

if true
  puts "Part 1 Example: #{part1(example_lines)}"
  puts "Part 2 Example: #{part2(example_lines)}"
end

if true
  puts "Part 1: #{part1(lines)}"
  puts "Part 2: #{part2(lines)}"
end
