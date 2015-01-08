class Container
  
  attr_accessor :arr, :remaining_blocks  
  def initialize(arr)
    @arr = arr
  end
  # Find the missing elements in the section
  def difference 
    complete 
    remaining 
  end

  def remaining
    Array(1..9) - arr
  end

  def arr
    @arr.map!(&:to_i)
  end

  def contain?(num)
    complete 
    arr.include? num
  end

  def pencil_in
  end


  def complete 
    if remaining.count == 1
      arr.map { |elem| elem == 0 ? remaining.first : elem }
    end
  end
end
