require_relative 'box'

class Grid
  attr_accessor :rows, :columns, :boxes
  def initialize(txt_file)
    @rows = Array.new(9) { Row.new([] ) }
    @columns = Array.new(9) { Column.new([]) }
    @boxes = Array.new(9) { Box.new([]) } 
    box_init(txt_file)
    row_init(txt_file)
    column_init(txt_file)
  end

  def box_init(txt_file)
    txt_file.each.with_index do |txt, ind|
       txt.split("").each_slice(3).with_index do |slice, index|
         @boxes[index + (ind / 3) * 3].arr += slice
       end
     end
  end

  def row_init(txt_file)
     txt_file.each.with_index do |txt, ind|
       @rows[ind].arr += txt.split("")
     end
  end

  def column_init(txt_file)
    txt_file.each.with_index do |txt, ind|
      txt.split("").each.with_index do |text, index|
        @columns[index].arr << text 
      end
    end 
  end

  def cross_hatching(box_num, num)
    remain = @boxes[box_num].difference
    box = @boxes[box_num].arr.each_slice(3).map{ |a| a }
    row_start = (box_num / 3) * 3 
    row_end = row_start + 3
    c_rows = @rows[row_start...row_end]
    cols_start = ( box_num % 3) * 3
    cols_end = cols_start + 3   
    c_cols = @columns[cols_start...cols_end]
    
    puts c_rows.to_s
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
         @boxes[box_num].arr[(x * 3) + y] = num
         c_rows[x].arr[(box_num % 3) * 3 + x] = num   
         c_cols[y].arr[(box_num / 3) * 3 + y] = num 
      end
      possible.clear
    end
    return box 
  end

end
