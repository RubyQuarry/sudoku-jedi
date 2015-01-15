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


  context "complete game" do 
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

  context "point conversion" do 
    it "is a point with correct remaining numbers" do
      grid.point_solution
      expect(grid.points.map { |p| p.value}.include? 0).to eql(false)
    end
    
    it "solves with points" do
      @new_grid = Grid.new(%w{400270600
                              798156234
                              020840007
                              237468951
                              849531726
                              561792843
                              082015479
                              070024300
                              004087002})
       @new_grid.naked_pairs
       @new_grid.update_points { |p| p }
       expect(@new_grid.points[9 * 9 - 2].value).to eq(6)
    #  puts @new_grid.points[9*9 - 3].nums
    end
    it "solves a triplet" do
      @sec_grid = Grid.new(%w{070408029
                              002000004
                              854020007
                              008374200
                              020000000
                              003261700
                              000093612
                              200000403
                              130642070})
      @sec_grid.intersection_removal
      @sec_grid.naked_pairs
      expect(@sec_grid.points[9 * 4 + 6].value).to eql(3)
      expect(@sec_grid.points[9*9 - 1 - 2].nums).to eql([5,8,9])
      @sec_grid.point_solution
      expect(@sec_grid.print_values).to eql("671438529392715864854926137518374296726859341943261785487593612269187453135642978")
    end

     it "solves a hard puzzle" do
       @hard_grid = Grid.new(%w{300200000
                                000107000
                                706030500
                                070009080
                                900020004
                                010800050
                                009040301
                                000702000
                                000008006})
       @hard_grid.point_solution
       expect(@hard_grid.print_values).to eql("351286497492157638786934512275469183938521764614873259829645371163792845547318926")
    end

    it "solves x-wing puzzle" do 
      @x_grid = Grid.new(%w{043080250
                            600000000
                            000001094
                            900004070
                            000608000
                            010200003
                            820500000
                            000000005
                            034090710})
      # @x_grid.point_solution
      # expect(@x_grid.print_values).to eql("143986257679425381285731694962354178357618942418279563821567439796143825534892716")
  end
end
