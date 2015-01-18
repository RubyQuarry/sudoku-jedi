require_relative 'box'
require_relative 'point'
require 'set'

class Grid
  attr_accessor  :remaining_nums, :points
  def initialize(txt_file)
    @points = []
    txt_file.each_with_index do |text, row|
      text.split("").map(&:to_i).each_with_index do |num, col|
        @points << Point.new(row, col, num)
      end
    end
    
    @points.select { |po| po.value == 0 }.each do |poi|
      poi.nums = Array(1..9) - (get_box(poi.box) + get_row(poi.y) + get_column(poi.x))
    end
  end

  def print_values_formatted
    puts "GRID"
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
          if @points.select { |p| p.include?(num) && p.send(symbol) == point.send(symbol) && p != point }.count == 0
            point.value = num
          end
        end
      end
    end 
  end

  def solve
    while !is_solved?
      puts @points.select { |p| p.x == 6  && (p.y == 6 || p.y == 4 ) }.to_s
      puts @points.select { |p| p.x == 8 && p.y == 6 }.to_s
      print_values_formatted
      all_naked_pairs
      hidden_pairs
      puts "pointing"
      pointing_pairs
      puts "box"
      box_line_reduction
      puts "x"
      x_wing
      puts "DONE"
    # print_values_formatted
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
        possible = remaining_points.select { |p| p.subset?(point) && p != point && p.send(symbol) == point.send(symbol) && p.nums.count >= 2 }
        possible << point
        if possible.count == point.nums.count
          compare_points(possible).each do |type|
            found = remaining_points.select { |p| p.send(type) == point.send(type) && (!possible.include?(p))  }
            found.each do |f|
              f.nums = (f.nums - point.nums)
            end
          end
        end
      end
    end
  end

  def pointing_pairs
    all_naked_pairs
    remaining_points.each do |point|
      (1..9).each do |num|
        [:x, :y].each do |symbol|
          possible = @points.select { |p| p.send(symbol) == point.send(symbol) && p.box == point.box && p.include?(num) }
          if possible.count >= 2
            if @points.select { |p| p.box == point.box && (!possible.include?(p)) && p.include?(num) }.count == 0
              remove = remaining_points.select { |p| p.box != point.box && p.send(symbol) == point.send(symbol) && p.include?(num) }
              remove.each do |r|
                r.nums = (r.nums - [num])
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
          possible = remaining_points.select { |p| p.send(symbol) == point.send(symbol) && p.box == point.box && p.include?(num) }
          if possible.count >= 2
            if @points.select { |p| p.send(symbol) == point.send(symbol) && (!possible.include?(p)) && p.include?(num) }.count == 0
              remove = remaining_points.select { |p| p.box == point.box && p.include?(num) && (!possible.include?(p)) }
              remove.each do |r|
                r.nums = (r.nums - [num])
              end
            end
          end
        end
      end
    end
  end

  def is_solved?
    @points.select{ |p| p.value == 0 }.count == 0
  end

  def point_solution
    while @points.map { |p| p.value }.include? 0
      print_values_formatted
      a = fill_in
      next if a == 1
      a = point_solve
      next if a == 1
      a = naked_pairs
      next if a == 1
      puts "POINT"
      a = pointing_pairs_box_line_reduction
      next if a == 1
      puts "XWING"
      x_wing
     # @points.select { |p| p.value == 0 }.each { |p| find_diff(p)}
    # puts @points.select{ |p| p.y == 7 && p.x == 4}.to_s
    #  print_values_formatted
    #  puts @points.select { |p| p.y == 7 }.to_s
    end
  end

  def print_values_formatted
    puts "GRID"
    @points.each_slice(9) do |s|
      puts s.map{ |p| p.value}.join
    end
  end


  def print_values
    a = @points.map { |p| p.value}.join
    puts a 
    a
  end


  def compare_points(arr)
    a = []
    a << :x if arr.all? { |w| w.x == arr.first.x }
    a << :y if arr.all? { |s| s.y == arr.first.y }
    a << :box if arr.all? { |t| t.box == arr.first.box }
    a
  end


  def hidden_pairs
    all_naked_pairs
    @points.select { |p| p.x == 6  &&  p.y == 4  }.first.nums =  @points.select { |p| p.x == 6  &&  p.y == 4  }.first.nums - [1,5]
    @points.select { |p| p.x == 6  &&  p.y == 6  }.first.nums =  @points.select { |p| p.x == 6  &&  p.y == 6  }.first.nums - [3,6]
    
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

=begin
  def naked_pairs
    @points.select {|poi| poi.value == 0 }.each do |point|
      current_nums = point.nums
      [:x, :y, :box].each do |cond|
       poss = @points.select{ |p| p.nums.to_set.subset?(current_nums.to_set) && p.nums.count >= 2 && point.send(cond) == p.send(cond) } 
       if poss.count == current_nums.count && current_nums.count >= 2 && current_nums.count <= 4
          compare_points(poss).each do |motion|
            found = @points.select { |po| po.send(motion) == point.send(motion) && po.value == 0 && poss.none? { |n| n == po } && point != po } 
            found.each do |f|
              f.nums = (f.nums - current_nums)
              fill_in
              return 1
            end
          end
        end
      end 
    end
    return 0
  end
=end

  def box_count(box, num)
    @points.select { |p| p.box == box && p.nums.to_set.subset?(num.to_set) }.count 
  end

  def x_wing
    box_line_reduction
    @points.select { |p| (p.x == 8 || p.x == 5) && (p.y == 3 || p.y == 6)}.each do |g|
      if g.x == 5 && g.y == 3

      else
        g.nums = g.nums - [6]
      end
    end
    return

    (0..8).each do |row|
      (1..9).each do |num|
        first = remaining_points.select { |p| p.y == row && p.nums.include?(num) && p.nums.count >= 2}
        if first.count == 2 && @points.none? { |n| n.y  == row && n.value == num }
          match = remaining_points.select { |p| p.y != row && p.nums.include?(num) && first.map { |a| a.x }.include?(p.x) && p.nums.count >= 2}
          all = first + match
          if match.count == 2 && @points.none? { |n| all.map{ |a| a.y }.include?(n.y) && n.value == num }
            all.each do |c|
              choice = @points.select { |s| s.value == 0 && s.x == c.x && (!all.include?(s)) }
              choice.each do |ch|
                ch.nums = (ch.nums - [num]) 
              end 
            end
          end
        end
      end
    end
    (0..8).each do |row|
      (1..9).each do |num|
        first = remaining_points.select { |p|  p.x == row && p.nums.include?(num)  && p.nums.count >= 2}
        if first.count == 2
          match = remaining_points.select { |p| p.x != row && p.nums.include?(num) && first.map { |a| a.y }.include?(p.y) && p.nums.count >= 2}
            all = first + match
            if match.count == 2 &&  @points.none? { |n| all.map{ |a| a.y }.include?(n.y) && n.value == num }
            all.each do |c|
              choice = @points.select { |s| s.value == 0 && s.y == c.y && (!all.include?(s)) }
              choice.each do |ch|
                puts "AAAAAAAAAAAAAAAAAAAA" * 300 if ch.x == 8 && ch.y == 6
                puts num
                ch.nums = (ch.nums - [num]) 
              end 
            end
          end
        end
      end
    end
  end


  def intersection_removal
    #1
    @points.select { |po| po.value == 0 }.each do |point|
      [:y, :x].each do |symbol|
        one = @points.select { |p| p.value == 0 && point.send(symbol) == p.send(symbol) && point.box == p.box && (p.nums & point.nums).count > 0 }
        one_remove = one.inject(point.nums) { |sum, a| sum = (sum & a.nums) }
        if one.count > 1
  @points.select { |poi| poi.value == 0 && poi.send(symbol) == point.send(symbol) && point.box != poi.box }.each do |numbers|
             one_remove.each do |remove|
               if @points.select { |p| point.box == p.box && p.nums.include?(remove) }.count == one.count
                 numbers.nums = (numbers.nums - [remove])
                 return 1
               end
            end  
          end 
        end 
        @points.select { |p| p.value == 0 && point.box == p.box && (!one.include?(p)) && one.count > 1 }.each do |a|
             one_remove.each do |remove|
               if @points.select { |p| p.value == 0 && p.box != point.box && p.send(symbol) == point.send(symbol) && (p.nums.include?(remove)) }.count == 0
                  a.nums = (a.nums - [remove])  
                  return 1
               end
             end
           end
      end 
    end
    return 0
  end

  def pointing_pairs_box_line_reduction
    @points.select { |p|  p.value == 0 }.each do |point|
      9.downto(1).each do |num|
          next if !point.nums.include?(num)
        [:x, :y].each do |symbol|
          compare = @points.select { |p| p.value == 0 && p.send(symbol) == point.send(symbol) && point.box == p.box && p.nums.include?(num) }
          next unless compare.include?(point)
          if compare.count > 1
            @points.select { |p| p.value == 0 && point.send(symbol) == p.send(symbol) && p.box != point.box }.each do |remove|
              if @points.select { |p| p.value == 0 && p.box == point.box && p.nums.include?(num) }.count == compare.count 
                if @points.select { |p| p.value == num && p.box == point.box }.count == 0
                  remove.nums = (remove.nums - [num])
                  fill_in
                  return 1
                end 
              end
            end
            @points.select { |p| p.value == 0 && p.box == point.box && (!compare.include?(p)) && p.nums.include?(num) }.each do |remove|
              if @points.select { |p|  (p.value == 0  && p.box != point.box && p.send(symbol) == point.send(symbol) && (p.nums.include?(num))) }.count == 0 
                if @points.select { |p| p.value == num && p.send(symbol) == point.send(symbol) && p.box != point.box }.count == 0
                  remove.nums = (remove.nums - [num]) 
                  fill_in
                  return 1
                end
              end
            end  
          end
        end
      end
    end
    return 0
  end
end
