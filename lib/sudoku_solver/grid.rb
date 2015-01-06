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
end
