require 'spec_helper'
describe Box do 
  let(:box) { Box.new([1,2,4,5,6,7,8,9])}
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
