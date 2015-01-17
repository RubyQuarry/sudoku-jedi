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

  context "point conversion" do 
    
    it "solves with points" do
      @new_grid = Grid.new(%w{050030090
                              200000007
                              400507008
                              345601879
                              791000265
                              800000003
                              502403906
                              683050741
                              910070032})
      @new_grid.solve
      expect(@new_grid.is_solved?).to eql(true)
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
      @sec_grid.solve
      expect(@sec_grid.print_values).to eql("671438529392715864854926137518374296726859341943261785487593612269187453135642978")
    end
=begin
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
      puts "hard grid"
       @x_grid.point_solution
       puts "-----------"
       expect(@x_grid.print_values).to eql("143986257679425381285731694962354178357618942418279563821567439796143825534892716")
    end
=end
  end
end
