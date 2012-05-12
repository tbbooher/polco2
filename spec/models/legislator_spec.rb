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
    b.pull_in_roll("h2012-86.xml")
    roll = b.rolls.first
    roll.record_legislator_votes   # loads the legislator vote table
    @l.vote_on(b).should eq(:aye)
    @l.bills_voted_on.first.should eq(b.id)
  end

  it "should be able to read in all legislators" do
    Legislator.update_legislators
    # should be at least the number of reps (435) + the number of senators
    Legislator.all.size.should eq (836)
  end
#
#test "We should get their party name" do
#  assert_equal("Republican", @legislator.party)
#end
#
it "We should be able to read their full state name" do
  @l.state.should eq("NY")
end
#

#
#test "We should be able to update all legislators" do
#  Legislator.destroy_all
#  Legislator.update_legislators
#  # should be at least the number of reps (435) + the number of senators
#  assert_operator Legislator.all.count, :>=, 535
#end
#
#test "We should be able to get the most recent actions from a legislator" do
# not sure if we want to do this . . .
#  legislator_result = YAML::load(File.open("#{Rails.root}/test/fixtures/govtrack_person.yml"))
#  role = Legislator.find_most_recent_role(legislator_result)
#  assert_equal Date.parse("2009-01-06"), role[:startdate]
#end
#
it "should be able to add constituents for state and district" do
  user = FactoryGirl.create(:user)
  @l.state_constituents << user
  @l.district_constituents << user
  @l.state_constituents.count.should eq(1)
  @l.district_constituents.count.should eq(1)
end

end