require 'spec_helper'

describe Roll do

  it "should be able to get a roll tally" do
    load_legislators
    b = FactoryGirl.create(:bill, bill_type: 'h', congress: '112', bill_number: '26', govtrack_id: 'h112-26')
    b.pull_in_roll("h2011-9.xml")
    b.rolls.first.tally.should eq({:ayes=>236, :nays=>182, :abstains=>16, :presents=>0})
  end

  it "should not import a roll multiple times" do
    pending
  end
end
