require 'spec_helper'

describe PolcoGroup do
  before :each do
    # need state and district
    @oh = FactoryGirl.create(:oh)
    @d = FactoryGirl.create(:district)
    usrs = FactoryGirl.create_list(:random_user, 3, {state: @oh, district: @d})
    grps = FactoryGirl.create_list(:polco_group, 5)
    usrs[0].joined_groups << [grps[0..2]]
    usrs[1].joined_groups << [grps[3..4]]
    usrs[2].joined_groups << [grps[2..3]]
    # user 0 => 0,1,2
    # user 1 => 3,4
    # user 2 => 2,3
    # means that 2=>0,2, 3=> 1,2 and 4,0,1=> one
    @usrs = usrs
    @grps = grps
  end

  it "should show the votes in each polco group" do
    b = FactoryGirl.create(:bill)
    b.vote_on(@usrs[0], :aye)
    b.vote_on(@usrs[1], :nay)
    b.vote_on(@usrs[2], :aye)
    Vote.all.size.should eq(3)
    b.vote_count.should eq(3)
  end

  it "should show how the district and state are voting on a specific bill" do
    b = FactoryGirl.create(:bill)
    b.vote_on(@usrs[0], :aye)
    b.vote_on(@usrs[1], :nay)
    b.vote_on(@usrs[2], :aye)
    @oh.reload
    @d.reload
    @oh.format_votes_tally(b).should eq("2, 1, 0")
    @d.format_votes_tally(b).should eq("2, 1, 0")
  end

  it "should have a rep if it is a district" do
    @d.the_rep.should eq("Vacant")
  end

  it "should have constituents for a district" do
    #has_many :constituents, class_name: "User", inverse_of: :district
    @d.constituents.size.should eq(3)
  end

  it "should have state constituents" do
    @oh.state_constituents.size.should eq(3)
  end

  it "should have lots of followers and members" do
    #has_and_belongs_to_many :members, :class_name => "User", :inverse_of => :joined_groups # uniq: true
    #has_and_belongs_to_many :followers, :class_name => "User", :inverse_of => :followed_groups #, uniq: true
    @grps[3].members.size.should eq(2)
    @grps[0].members.size.should eq(1)
    @grps[3].followers.size.should eq(0)
  end

  it "should show the vote count in each group" do
    b = FactoryGirl.create(:bill)
    b.vote_on(@usrs[0], :aye)
    b.vote_on(@usrs[1], :nay)
    b.vote_on(@usrs[2], :aye)
    @grps[2].votes.size.should eq(2)
    @grps[2]
    PolcoGroup.where(type: :common).first.votes.size.should eq(3)
  end

  it "should have a member, vote and follower count" do
    b = FactoryGirl.create(:bill)
    b.vote_on(@usrs[0], :aye)
    b.vote_on(@usrs[1], :nay)
    b.vote_on(@usrs[2], :aye)
    # means that 2=>0,2, 3=> 1,2 and 4,0,1=> one
    @grps[2].update_counters
    @grps[2].member_count.should eql(2)
    @grps[2].vote_count.should eql(2)
    @grps[2].follower_count.should eql(0)
    @grps[1].update_counters
    @grps[1].member_count.should eql(1)
    @grps[1].vote_count.should eql(1)
  end

  it "should be able to show the rep for a district (and fail gracefully if it doesn't exist)" do
    d = FactoryGirl.create(:polco_group, name: nil, type: :district)
    d.the_rep.should eql("Only districts can have a representative")
  end

end