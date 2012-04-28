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
    u.joined_group_ids.size.should eq(6)
    u.save
    u.joined_groups.size.should eq(2)
  end
end
