require 'spec_helper'

describe Vote do
  it "should record the number of votes for a bill on each vote" do
    usrs = FactoryGirl.create_list(:random_user, 3)
    b = FactoryGirl.create(:bill)
    b.vote_on(usrs[0], :aye)
    b.vote_on(usrs[1], :nay)
    b.vote_on(usrs[2], :aye)
    Vote.all.size.should eq(3)
    b.vote_count.should eq(3)
  end

end