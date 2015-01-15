require_relative 'box'
require_relative 'point'
require 'set'

class Grid
  attr_accessor :rows, :columns, :boxes, :remaining_nums, :points
  def initialize(txt_file)
    @rows = Array.new(9) { Row.new([] ) }
    @columns = Array.new(9) { Column.new([]) }
    @boxes = Array.new(9) { Box.new([]) } 
    @points = []
    txt_file.each_with_index do |text, row|
      text.split("").map(&:to_i).each_with_index do |num, col|
        @points << Point.new(row, col, num)
      end
    end
    
    #find_diff(@points[0])
    #puts @points[0].inspect
    @points.select { |po| po.value == 0 }.each do |poi|
      poi.nums = Array(1..9) - (get_box(poi.box) + get_row(poi.y) + get_column(poi.x))
    end


    box_init(txt_file)
    row_init(txt_file)
    column_init(txt_file)
  end

  def box_init(txt_file)
    txt_file.each.with_index do |txt, ind|
       txt.split("").each_slice(3).with_index do |slice, index|
         @boxes[index + (ind / 3) * 3].arr += slice.map(&:to_i)
       end
     end
  end
  
  def row_init(txt_file)
     txt_file.each.with_index do |txt, ind|
       @rows[ind].arr += txt.split("").map(&:to_i)
     end
  end

  def column_init(txt_file)
    txt_file.each.with_index do |txt, ind|
      txt.split("").map(&:to_i).each.with_index do |text, index|
        @columns[index].arr << text 
      end
    end 
  end

  def complete?
    !@rows.inject([]) { |sum, a| sum += a.arr }.include? 0
  end

  def point_to_contents(point)
    d = point.blank_spaces
    # puts point.position
    #puts @boxes[d[0]].arr.to_s , @columns[d[2]].arr.to_s , @rows[d[1]].arr.to_s    
    @boxes[d[0]].arr + @columns[d[2]].arr + @rows[d[1]].arr    
  end

  def blank
    @rows.each_with_index do |row, index|
      row.arr.each_with_index do |elem, ind|
        if elem == 0
          point = Point.new(ind, index)
          point.nums = Array(1..9) - point_to_contents(point)
          @points << point
    #     puts @points.to_s  
        end
      end
    end
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

  # fill in value if only possibility left
  def easy_fill_in
    @points.each do |p|
      if p.nums.count == 1
        p.value = p.nums.first
      end
    end
  end
  
  def update_points 
    @points.select { |po| po.value == 0 }.each do |poi|
      find_diff(poi)
    end
    easy_fill_in
    (0..8).each do |num|
      [:box, :x, :y].each do |fields|
        yield @points.select { |p| p.send(fields) == num }
      end
    end
  end 

  def point_solve
    num = 0
    100.times do |t|
      [:box, :x, :y].each do |selection|
        box = @points.select { |point| point.send(selection) == num }
        finders = Array(1..9) - box.map{ |b| b.value }
        finders.each do |n|
          crossed = box.select { |po| po.nums.include? n }
          if crossed.count == 1
            crossed.first.value = n
            update_points do |cols| 
              if cols.map { |c| c.value }.count(0) == 1
                cols.select { |s| s.value == 0 }.first.value = (Array(1..9) - (cols.map { |f| f.value })).first
              end
            end 
          end
        end
      end 
      num = (num + 1) % 9
    end
  end

  def point_solution
    while @points.map { |p| p.value }.include? 0
      point_solve
      x_wing
      naked_pairs
      intersection_removal
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

  def naked_pairs
    @points.select {|poi| poi.value == 0 }.each do |point|
      current_nums = point.nums
      [:x, :y, :box].each do |cond|
poss = @points.select{ |p| p.nums.to_set.subset?(current_nums.to_set) && p.nums.count >= 2 && point.send(cond) == p.send(cond) } 
        if poss.count == current_nums.count && current_nums.count >= 2
          compare_points(poss).each do |motion|
            found = @points.select { |po| po.send(motion) == point.send(motion) && po.value == 0 && poss.none? { |n| n == po } && point != po } 
            found.each do |f|
              f.nums = (f.nums - current_nums)
            end
          end
        end
      end 
    end
  end
  
  def box_count(box, num)
    @points.select { |p| p.box == box && p.nums.to_set.subset?(num.to_set) }.count 
  end

  def intersection_removal
    #1
    @points.select { |po| po.value == 0 }.each do |point|
      [:x, :y].each do |symbol|
        one = @points.select { |p| p.value == 0 && point.send(symbol) == p.send(symbol) && point.box == p.box && (p.nums & point.nums).count > 0 }
        one_remove = one.inject(point.nums) { |sum, a| sum = (sum & a.nums) }
        if one.count > 1
  @points.select { |poi| poi.value == 0 && poi.send(symbol) == point.send(symbol) && point.box != poi.box }.each do |numbers|
             one_remove.each do |remove|
               if @points.select { |p| point.box == p.box && p.nums.include?(remove) }.count == one.count
                 numbers.nums = (numbers.nums - [remove])
               end
            end  
          end 
        end 
        @points.select { |p| p.value == 0 && point.box == p.box && (!one.include?(p)) && one.count > 1 }.each do |a|
             one_remove.each do |remove|
               if @points.select { |p| p.value == 0 && p.box != point.box && p.send(symbol) == point.send(symbol) && (p.nums.include?(remove)) }.count == 0
                  a.nums = (a.nums - [remove])
               end
             end
           end
      end 
    end
  end

  def x_wing
    (0..8).each do |row|
      (1..9).each do |num|
        first = @points.select { |p| p.y == row && p.nums.include?(num) }
        if first.count == 2
          match = @points.select { |p| p.y != row && p.nums.include?(num) && first.map { |a| a.x }.include?(p.x) }
          if match.count == 2
            all = first + match
           #puts all.to_s
            all.each do |c|
              choice = @points.select { |s| s.x == c.x && (!all.include?(s)) }
              choice.each do |ch|
           #    puts "DONE"
                ch.nums = (ch.nums - [num]) 
              end 
            end
          end
        end
      end
    end
    (0..8).each do |row|
      (1..9).each do |num|
        first = @points.select { |p| p.x == row && p.nums.include?(num) }
        if first.count == 2
          match = @points.select { |p| p.x != row && p.nums.include?(num) && first.map { |a| a.y }.include?(p.y) }
          if match.count == 2
            all = first + match
            all.each do |c|
              choice = @points.select { |s| s.y == c.y && (!all.include?(s)) }
              choice.each do |ch|
           #    puts "DONE Y"
                ch.nums = (ch.nums - [num]) 
              end 
            end
          end
        end
      end
    end
  end

  def cross_hatching(box_num)
    remain = boxes[box_num].difference
    return if remain.count == 0
    box = boxes[box_num].arr.each_slice(3).map{ |a| a }
    row_start = (box_num / 3) * 3 
    row_end = row_start + 3
    c_rows = rows[row_start...row_end]
    cols_start = ( box_num % 3) * 3
    cols_end = cols_start + 3   
    c_cols = columns[cols_start...cols_end]
    
    possible = []
    remain.each do |num|
      3.times do |a|
        3.times do |b|
          if box[a][b] == 0
            if !c_rows[a].contain?(num) && !c_cols[b].contain?(num)     
              possible << [a,b]
            end
          end
        end
      end
      if possible.count == 1
         x, y = possible.first 
         box[x][y] = num 
         boxes[box_num].arr[(x * 3) + y] = num
         c_rows[x].arr[(box_num % 3) * 3 + y] = num   
         c_cols[y].arr[(box_num / 3) * 3 + x] = num 
      end
      possible.clear
    end
    box 
  end
   
  def solve
    num = 0
    until complete?
      cross_hatching(num % 9)
      num += 1
    end
  end
end
