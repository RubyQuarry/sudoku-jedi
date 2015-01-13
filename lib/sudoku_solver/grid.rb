require_relative 'box'
require_relative 'point'

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
    
    @points.select {|p| p.value == 0 }.each do |point|
#point.nums += (Array(1..9)-(find_diff(get_box(point.box))+find_diff(get_row(point.y))+find_diff(get_column(point.x)))) 
    end
    find_diff(@points[0])
    puts @points[0].inspect
    @points.select { |po| po.value == 0 }.each do |poi|
      find_diff(poi)
    end
    point_solve


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

  def find_diff(point)
    point.nums = Array(1..9) - (get_box(point.box) + get_row(point.y) + get_column(point.x))
  end

  def flat_points
    @points.select { |p| p.value == 0 }
  end

  def get_values(arr)
    arr.map { |b| b.value }
  end


  def iter_boxes(num)
    box_diff(get_box(num))
  end

  def point_solve
    num = 0
    while @points.select { |p| p.value != 0 }.count > 0
      box = @points.select { |point| point.box == num }
      Array(1..9).each do |n|
        next if 
        crossed = box.select { |po| po.nums.include? n }
        if crossed.count == 1
          crossed.first.value = n
        end
      end
      num = (num + 1) % 9
    end
  end

  


  def hidden_pairs
    @points.each do |point|


    end
  end

  def naked_subset

  end

  def x_wing
    @points.each do |point|
      compare = point.nums
      @points.select{ |p| p if (p.x == point.x || p.y == point.y) && (compare + p.nums).count >= 1}    
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
