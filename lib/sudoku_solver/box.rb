require_relative 'container'
class Box
  include Container 
  attr_accessor :box
  def initialize(arr)
    @box = arr
  end
  
end
