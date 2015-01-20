require 'sudoku_solver/point'
require 'set'

class Grid
  attr_accessor  :remaining_nums, :points
  def initialize(txt_file)
    @points = []
    @arr = []
    txt_file.each_with_index do |text, row|
      text.split("").map(&:to_i).each_with_index do |num, col|
        @points << Point.new(row, col, num)
      end
    end
    
    remaining_points.each do |poi|
      poi.nums = Array(1..9) - (get_box(poi.box) + get_row(poi.y) + get_column(poi.x))
    end
  end

  def print_values_formatted
    puts "SOLUTION"
    @points.each_slice(9) do |s|
      puts s.map{ |p| p.value}.join
    end
  end

  def print_values
    a = @points.map { |p| p.value}.join
    puts a 
    a
  end

  def get_box(num)
    @points.select { |point| point.box == num }.map { |b| b.value }
  end

  def get_row(num)
    @points.select { |point| point.y == num }.map { |b| b.value }
  end

  def get_column(num)
    @points.select { |point| point.x == num }.map { |b| b.value }
  end

  def fill_row(num)
    @points.select { |point| point.x == num  }
  end

  def find_diff(point)
    point.nums = point.nums - (get_box(point.box) + get_row(point.y) + get_column(point.x))
  end 

  def flat_points
    @points.select { |p| p.value == 0 }
  end

  def get_values(arr)
    arr.map { |b| b.value }
  end

  def update_points 
    @points.select { |po| po.value == 0 }.each do |poi|
      find_diff(poi)
    end
    (0..8).each do |num|
      [:box, :x, :y].each do |fields|
        yield @points.select { |p| p.send(fields) == num }
      end
    end
  end 

  def fill_in
    remaining_points.each do |p|
      find_diff(p)
    end
  end


  def remaining_points
    @points.select { |p| p.value == 0 }
  end

  def components
    [:x, :y, :box]
  end

  def pinned_points
    remaining_points.each do |point|
      components.each do |symbol|
        point.nums.each do |num|
          if contains_number_in_unit(point, symbol, num).count == 0
            point.value = num
          end
        end
      end
    end 
  end

  def contains_number_in_unit(point, symbol, num)
    @points.select do |p|
      p.include?(num) &&
      p.send(symbol) == point.send(symbol) &&
      p != point
    end
  end

  def solve
    while !is_solved?
      all_naked_pairs
      hidden_pairs
      pointing_pairs
      box_line_reduction
      x_wing
    end
  end

  def all_naked_pairs
    fill_in
    pinned_points
    naked_pairs
  end

  def naked_pairs
    remaining_points.each do |point|
      next if point.nums.count <= 1
      components.each do |symbol|
        possible = naked_pair_possibility(point, symbol)
        possible << point
        if possible.count == point.nums.count
          compare_points(possible).each do |type|
            found = remaining_points.select { |p| p.send(type) == point.send(type) && (!possible.include?(p))  }
            found.each do |f|
              f.nums -= point.nums 
            end
          end
        end
      end
    end
  end

  def naked_pair_possibility(point, symbol)
    remaining_points.select do |p|
      p.subset?(point) &&
      p.send(symbol) == point.send(symbol) &&
      p.nums.count >= 2 &&
      p != point
    end
  end

  def pointing_pairs
    all_naked_pairs
    remaining_points.each do |point|
      (1..9).each do |num|
        [:x, :y].each do |symbol|
          possible = same_row_and_box(point, num, symbol)
          if possible.count >= 2
            if same_box_differant_streak(point, num, symbol, possible).count == 0
              remove = same_row_different_box(point, num, symbol)
              remove.each do |r|
                r.nums -= [num]
              end
            end
          end
        end
      end
    end
  end

  def box_line_reduction
    pointing_pairs
    remaining_points.each do |point|
      (1..9).each do |num|
        [:x, :y].each do |symbol|
          reduce(point, num, symbol)
        end
      end
    end
  end
  
  def reduce(point, num, symbol)
    possible = same_row_and_box(point, num, symbol)
    if possible.count >= 2
      if same_box_differant_streak(point, num, symbol, possible).empty?
        remove = same_box_differant_streak(point, num, :box, remaining_points)
        remove.each do |r|
          r.nums -= [num]
        end
      end
    end
  end

  def same_box_differant_streak(point, num, symbol, possible, selection= @points)
    selection.select do |p|
      p.send(symbol) == point.send(symbol) &&
      p.include?(num) &&
      (!possible.include?(p))
    end
  end

  def same_row_and_box(point, num, symbol)
    remaining_points.select do |p|
      p.send(symbol) == point.send(symbol) &&
      p.box == point.box &&
      p.include?(num)
    end
  end

  def same_row_different_box(point, num, symbol)
    remaining_points.select do |p|
      p.send(symbol) == point.send(symbol) &&
      p.box != point.box &&
      p.include?(num)
    end
  end

  def is_solved?
    @points.select{ |p| p.value == 0 }.count == 0
  end

  def print_values_formatted
    puts "GRID"
    @points.each_slice(9) do |s|
      puts s.map{ |p| p.value}.join
    end
  end


  def compare_points(arr)
    a = []
    a << :x if arr.all? { |w| w.x == arr.first.x }
    a << :y if arr.all? { |s| s.y == arr.first.y }
    a << :box if arr.all? { |t| t.box == arr.first.box }
    a
  end

  # Does not work for now
  def hidden_pairs
    all_naked_pairs
    
    remaining_points.each do |point|
      next if point.nums.count <= 1
      point.nums.combination(2).each do |arr|
        components.each do |symbol|
          remove = @points.select { |p| p.send(symbol) == point.send(symbol) && arr.to_set.subset?(p.nums.to_set) && p.nums.count >= 2}
          if remove.count == 2 && @points.select { |p| p.send(symbol) == point.send(symbol) && ( arr.include?(p.value)) }.count == 0
            #remove.each { |r| r.nums = arr }
            return
          end
        end 
      end
    end
  end

  def box_count(box, num)
    @points.select { |p| p.box == box && p.nums.to_set.subset?(num.to_set) }.count 
  end

  def x_wing
    box_line_reduction
    remaining_points.each do |point|
      point.nums.each do |num|
        [:x, :y].each do |symbol|
          x_wing_procedure(symbol, point, num)
        end
      end
    end 
  end

  def x_wing_procedure(symbol, point, num)
    @arr = first_row(symbol, num, point)
    if first_x_wing_check(point, num, symbol)
      last = second_x_wing_set(symbol, num)
      if no_intstance_of_other_number_on_second_set?(last, symbol, num)
        delete_opposite_matches(last, symbol, num)
      end
    end
  end


  def first_x_wing_check(point, num, symbol)
    @arr.count == 2 &&
      @points.select do |p|
          p.value == num &&
          p.send(flip(symbol)) == point.send(flip(symbol))
      end.empty?    
  end
  

  def delete_opposite_matches(last, symbol, num)
    final = @arr + last
    places = final.map { |m| m.send(symbol) }.uniq
    remaining_points
      .select { |p| places.include?(p.send(symbol)) && (!final.include?(p)) }
      .each { |poi| poi.nums  -= [num] }
  end

  def first_row(symbol, num, point)
    @points.select do |p|
      p.nums.include?(num) &&
      p.send(flip(symbol)) == point.send(flip(symbol)) && 
      p.value == 0
    end
  end

  def second_x_wing_set(symbol, num)
    @points.select do |p|
      p.nums.include?(num) &&
      @arr.map { |a| a.send(symbol) }.include?(p.send(symbol)) &&
      (!@arr.include?(p)) &&
      p.value == 0 && 
      check_row(p.y, p, num, symbol)
    end
  end


  def no_instance_other_number?(symbol, num)
    @arr.count == 2 &&
    @points.select do |p| 
      p.value == num && p.send(flip(symbol)) == point.send(flip(symbol))
    end.empty?
  end

  def no_intstance_of_other_number_on_second_set?(last, symbol, num)
    last.all? { |x| x.send(flip(symbol)) == last.first.send(flip(symbol)) } &&
                    last.count == 2 &&
                    @points.select do |p| 
                      p.value == num &&
                      p.send(flip(symbol)) == last.first.send(flip(symbol)) 
                    end.empty?
  end

  def check_row(row, point, num, symbol)
    a = @points.select { |p| p.send(flip(symbol)) == row && p != point  }.map { |x| x.nums }.flatten
    a.count(num) <= 1
  end

  def flip(n)
    n == :y ? :x : :y
  end

end
