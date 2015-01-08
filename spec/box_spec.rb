require 'spec_helper'
describe Box do 
  let(:box) { Box.new([1,2,4,5,6,7,8,9], 0, 5)}
  context "Coordinates" do 
    it "is correct" do 
      expect(box.blank_spaces).to eql([1, 0, 5])
      @let_box = Box.new([], 8, 8)
      expect(@let_box.blank_spaces).to eql([8, 8, 8])
    end
  end
  context "#differance" do
    it "shows the incorrect differance" do
      expect(box.difference).to_not eql(Array(5..9))
    end
    it "show the correct differance" do 
      expect(box.difference).to eql([3])
    end
  end 
  context "#complete" do 
    it "completes the cell" do 
      @in_box = Box.new([1,0,3,4,5,6,7,8,9])
      expect(@in_box.complete).to eql(Array(1..9))
    end
  end
end
