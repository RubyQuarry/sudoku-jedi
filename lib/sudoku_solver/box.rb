require_relative 'container'

class Box < Container 
  attr_accessor :box
  def initialize(arr)
    super(arr)
  end
end
