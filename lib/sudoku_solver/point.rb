require 'set'

class Point
  attr_accessor :box, :x, :y, :nums, :value 

  # Represents a single point on a sudoku board
  # rows, boxes, and columns can vary from 0 to 8
  def initialize(y=0, x=0, value = 0)
    @value = value
    @x = x
    @y = y
    @nums = []
    @box = (y / 3) * 3 + (x / 3) 
  end

  def nums
    @nums.sort
  end

  def share(point)
    [].tap do |z|
      z << :box if @box == point.box
      z << :x if x == point.x
      z << :y if y == point.y
    end
  end

  def value=(val)
    if @value == 0
      @value = val
      if @value != 0 
        @nums = [val]
      end
    end
  end

  def nums=(n)
    if @value == 0
      @nums = n
      if @nums.count == 1
        @value = @nums.first
        @nums = [@value]
      end
    end
  end

  def include?(num)
    nums.include?(num) || (num == value)
  end

  def subset?(point)
    nums.to_set.subset?(point.nums.to_set)
  end

end

