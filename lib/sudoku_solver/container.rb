class Container
  extend Forwardable
  
  attr_accessor :arr 
  def initialize(arr)
    @arr = arr
  end
  # Find the missing elements in the section
  def difference 
    Array(1..9) - @arr
  end
end
