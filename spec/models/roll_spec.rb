require 'spec_helper'

describe Roll do

  it "should be able to get a roll tally" do
    load_legislators
    b = FactoryGirl.create(:bill, bill_type: 'h', congress: '112', bill_number: '26', govtrack_id: 'h112-26')
    Roll.pull_in_roll("h2011-9.xml").tally.should eq({:ayes=>236, :nays=>182, :abstains=>16, :presents=>0})
  end

  it "should not import a roll multiple times" do
    pending
  end

  it "should be able to get an associated roll call" do
    f = File.new("#{DATA_PATH}/rolls/h2011-9.xml", 'r')
    feed = Feedzirra::Parser::RollCall.parse(f)
    feed.bill_type.should eq('hr')
    feed.chamber.should eq('house')
    feed.bill_number.should eq("26")
    feed.roll_call.count.should eq(434)
  end

  it "and should be able to embed a roll" do
    load_legislators
    # govtrack_id = "#{feed.bill_type.first}#{feed.congress}-#{feed.bill_number}"
    # h2009-11.xml h2011-28.xml h2011-40.xml h2011-9.xml
    # a role should update the status of the bill
    b = FactoryGirl.create(:bill, bill_type: 'h', congress: '112', bill_number: '26', govtrack_id: 'h112-26')
    roll = Roll.pull_in_roll("h2011-9.xml")
    #roll = b.rolls.first
    roll.year.should eq(2011)
    roll.aye.should eq(236)
    b2 = FactoryGirl.create_list(:bill, 10)
    b = Bill.where(bill_type: 'h', congress: '112', bill_number: '26').first
    Bill.rolled_bills.house_bills.size.should eq(1)
    b.vote_summary.should eq({:ayes=>236, :nays=>182, :abstains=>16, :presents=>0})
    roll.legislator_votes.size.should eq(56)
  end

end
