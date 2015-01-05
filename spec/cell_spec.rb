require 'spec_helper'
describe Cell do
  let(:cell) { Cell.new(234) }
  it "#num" do
    expect(cell.num).to eql(234)
  end
end
