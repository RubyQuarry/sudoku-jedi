require_relative 'container'
class Box
  extend Container 
  attr_accessor :box
  def initialize(arr)
    @box = arr
  end

  def difference
    Box.difference(@box)
  end
  
end
