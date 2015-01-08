require_relative 'container'

class Box < Container 
  attr_accessor :box, :position

  def initialize(arr, y=0, x=0)
    super(arr)
    Struct.new("Coordinate", :x, :y) if !Struct::const_defined? "Coordinate"
    @position = Struct::Coordinate.new(x, y)
  end

    
  def blank_spaces
    [(position.y / 3) * 3 + (position.x / 3), position.y, position.x]
  end


end
