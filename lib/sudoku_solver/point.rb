require_relative 'container'

class Point
  attr_accessor :box, :position, :nums, :value 

  def initialize(y=0, x=0, value = 0)
    @value = value
    Struct.new("Coordinate", :x, :y) if !Struct::const_defined? "Coordinate"
    @position = Struct::Coordinate.new(x, y)
    @nums = []
    @box = (position.y / 3) * 3 + (position.x / 3) 
  end


  def x
    @position.x
  end

  def y
    @position.y
  end
    
  def blank_spaces
    [(position.y / 3) * 3 + (position.x / 3), position.y, position.x]
  end


end
