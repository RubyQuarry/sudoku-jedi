require 'thor'
require_relative 'grid'
class CLI < Thor

  desc "solve [FILE NAME]", "Solves a sudoku puzzle from a text file"
  def solve(file_name)
  	file = File.open(file_name,"rb")
  	contents = file.read.gsub("\n","")
  	contents.gsub!(" ","")
    grid = Grid.new(contents.scan(/\d{9}/))
    grid.solve
    grid.print_values_formatted
  end
end
