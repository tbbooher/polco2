require 'spec_helper'

describe User do
  it "should only be able to follow a group once" do
    g = FactoryGirl.create(:polco_group)
    u = User.create(name: 'tim', email: Faker::Internet.email)
    u.joined_group_ids << g.id
    u.should be_valid
    u.joined_group_ids << g.id
    u.joined_group_ids << g.id
    u.joined_group_ids << g.id
    u.joined_group_ids.size.should eq(5)
    u.save
    u.joined_groups.size.should eq(2)
  end

  it "should be able to show all bills by chamber a user has not voted on" do
    u = FactoryGirl.create(:user)
    create_20_and_vote_on_10(u)
    (u.bills_voted_on(:house).size + u.bills_voted_on(:senate).size).should eq(10)
    (u.bills_not_voted_on(:house).size + u.bills_not_voted_on(:senate).size).should eq(10)
    (u.bills_voted_on(:house)+u.bills_voted_on(:senate)).should include(Bill.first)
    not_voted_on_bills = Bill.all.to_a - Vote.all.map{|v| v.bill}
    (u.bills_not_voted_on(:house)+u.bills_not_voted_on(:senate)).map(&:id).should include(not_voted_on_bills.first.id)
  end

end
