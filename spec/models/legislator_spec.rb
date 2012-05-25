require 'spec_helper'

describe Legislator do

  before :each do
    @l = FactoryGirl.create(:legislator)
  end

  it "should have a party" do
    @l.party.should eql("Democrat")
  end

  it "should have a chamber" do
    @l.chamber.should eql("U.S. House of Representatives")
    #  assert_equal(, @legislator.chamber)
  end

  it "should have a list of votes on bills" do
    Legislator.update_legislators
    b = FactoryGirl.create(:bill, bill_type: 'h', congress: '112', bill_number: '1837', govtrack_id: 'h112-1837')
    roll = Roll.bring_in_roll("h2012-86.xml")
    #roll.record_legislator_votes   # loads the legislator vote table
    @l.vote_on(b).should eq(:aye)
    @l.bills_voted_on.first.should eq(b.id)
  end

  it " should show how they voted on a bill" do
    b = FactoryGirl.create(:bill)
    LegislatorVote.create(legislator_id: @l.id, bill_id: b.id, value: :aye)
    @l.vote_on(b).should eq :aye
  end

  it "should be able to read in all legislators" do
    Legislator.update_legislators
    # should be at least the number of reps (435) + the number of senators
    Legislator.all.size.should eq (836)
  end

  it "We should be able to read their full state name" do
    @l.state.should eq("NY")
  end

  it "should be able to add constituents for state and district" do
    user = FactoryGirl.create(:user)
    @l.state_constituents << user
    @l.district_constituents << user
    @l.state_constituents.count.should eq(1)
    @l.district_constituents.count.should eq(1)
  end

  it "should show senators votes on a bill" do
    b = FactoryGirl.create(:bill)
    s1 = FactoryGirl.create(:legislator, first_name: "chad")
    s2 = FactoryGirl.create(:legislator, first_name: "ryan")
    u = FactoryGirl.create(:user)
    LegislatorVote.create(legislator_id: s1.id, value: :aye, bill: b.id)
    LegislatorVote.create(legislator_id: s2.id, value: :nay, bill: b.id)
    u.senators << [s1, s2]
    u.save
    u.reload
    u.senators_vote_on(b).should eq([{:name=>"chad Ackerman", :value=>"aye"}, {:name=>"ryan Ackerman", :value=>"nay"}])
  end

end
