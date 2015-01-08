require 'spec_helper'

describe Grid do
  let(:grid) { Grid.new(%w{050400716
                           409061200 
                           106205400 
                           007046035 
                           680390007 
                           940050680
                           091003024
                           060904501 
                           704510060})}
  context "#load" do
    it "box inits" do
      expect(grid.boxes.inject([]) { |sum, a| sum += a.arr }).to eql(%w{0 5 0 4 0 9 1 0 6
                                                                        4 0 0 0 6 1 2 0 5 
                                                                        7 1 6 2 0 0 4 0 0 
                                                                        0 0 7 6 8 0 9 4 0
                                                                        0 4 6 3 9 0 0 5 0
                                                                        0 3 5 0 0 7 6 8 0 
                                                                        0 9 1 0 6 0 7 0 4
                                                                        0 0 3 9 0 4 5 1 0 
                                                                        0 2 4 5 0 1 0 6 0}.map(&:to_i))
    end

    it "row_init" do
      expect(grid.rows.inject([]) { |sum, a| sum += a.arr }).to eql(%w{0 5 0 4 0 0 7 1 6
                                                                       4 0 9 0 6 1 2 0 0
                                                                       1 0 6 2 0 5 4 0 0 
                                                                       0 0 7 0 4 6 0 3 5
                                                                       6 8 0 3 9 0 0 0 7  
                                                                       9 4 0 0 5 0 6 8 0 
                                                                       0 9 1 0 0 3 0 2 4 
                                                                       0 6 0 9 0 4 5 0 1 
                                                                       7 0 4 5 1 0 0 6 0 }.map(&:to_i))
    end
  it "column_init" do
      expect(grid.columns.inject([]) { |sum, a| sum += a.arr }).to eql(%w{0 4 1 0 6 9 0 0 7  
                                                                          5 0 0 0 8 4 9 6 0
                                                                          0 9 6 7 0 0 1 0 4
                                                                          4 0 2 0 3 0 0 9 5
                                                                          0 6 0 4 9 5 0 0 1
                                                                          0 1 5 6 0 0 3 4 0
                                                                          7 2 4 0 0 6 0 5 0
                                                                          1 0 0 3 0 8 2 0 6 
                                                                          6 0 0 5 7 0 4 1 0 }.map(&:to_i))
    end 
  end

  context "cross hatching" do
    it "basic solves" do
      expect(grid.cross_hatching(7)).to eql([[6,0,3],[9,0,4],[5,1,0]])
      expect(grid.rows[6].arr).to eql([0,9,1,6,0,3,0,2,4])
      expect(grid.columns[3].arr).to eql([4,0,2,0,3,0,6,9,5])
    end
    it "does not bug out" do
      grid.cross_hatching(3)
      expect(grid.boxes[3].arr).to eql([0,1,7,6,8,5,9,4,3])
    end

  end


  context "complet game" do 
    it "is NOT solved" do
      expect(grid.complete?).to eql(false)
    end

    it "is solved" do 
      grid.solve
      expect(grid.complete?).to eql(true)
      expect(grid.rows.inject([]) { |sum, a| sum += a.arr }).to eql(%w{8 5 2 4 3 9 7 1 6
                                                                       4 3 9 7 6 1 2 5 8
                                                                       1 7 6 2 8 5 4 9 3 
                                                                       2 1 7 8 4 6 9 3 5
                                                                       6 8 5 3 9 2 1 4 7  
                                                                       9 4 3 1 5 7 6 8 2 
                                                                       5 9 1 6 7 3 8 2 4 
                                                                       3 6 8 9 2 4 5 7 1 
                                                                       7 2 4 5 1 8 3 6 9 }.map(&:to_i))
    end
  end
end
