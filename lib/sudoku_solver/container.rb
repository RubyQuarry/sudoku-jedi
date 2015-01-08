class Container
  
  attr_accessor :arr 
  def initialize(arr)
    @arr = arr
  end
  # Find the missing elements in the section
  def difference 
    Array(1..9) - arr
  end

  def arr
    @arr.map!(&:to_i)
  end

  def contain?(num)
    arr.include? num
  end

  def complete 
    if difference.size == 1
      arr.map { |elem| elem == 0 ? difference.first : elem }
    end
  end
end
