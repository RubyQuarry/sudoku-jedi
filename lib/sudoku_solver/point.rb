require_relative 'container'

class Point
  attr_accessor :box, :position, :nums

  def initialize(y=0, x=0)
    Struct.new("Coordinate", :x, :y) if !Struct::const_defined? "Coordinate"
    @position = Struct::Coordinate.new(x, y)
    @nums = []
  end

    
  def blank_spaces
    [(position.y / 3) * 3 + (position.x / 3), position.y, position.x]
  end


end
