require 'spec_helper'

describe Bill do

  context "has basic properties and " do

    it "should be able to get a list of subjects for a bill" do
      #b = FactoryGirl.create(:bill)
      b = Bill.find_or_create_by(:title => "h3605", :govtrack_name => "h3605")
      b.update_bill
      b.subjects.size.should eql(15)
      b.subjects.last.name.should eql("Trade restrictions")
    end

    it "should have a long and a short title" do
      b = FactoryGirl.create(:bill)
      titles = b.titles
      titles.should_not be_nil
      b.long_title.should eql("This is the official title.")
      b.short_title.should eql("This is the short title")
    end

    it "should show the latest status for a bill" do
      b = FactoryGirl.create(:bill)
      b.bill_actions = [['2011-08-14', 'augustine'], ['2011-05-12', 'Cyril'], ['2001-09-15', 'Pelagius']]
      b.bill_state = 'REFERRED'
      b.get_latest_action[:description].should eq("augustine")
      b.bill_state.should eq('REFERRED')
    end

    it "should be able to get latest action" do
      b = FactoryGirl.create(:bill)
      b.get_latest_action.should eql({:date => "2011-02-17", :description => "Message on Senate action sent to the House."})
    end

    it "should increment a bill's count each time we vote" do
      b = FactoryGirl.create(:bill)
      u = FactoryGirl.create(:user)
      b.vote_on(u.id,:aye)
      b.vote_count.should eq(1)
    end

    it "should tell me the most popular bills" do
      users = FactoryGirl.create_list(:random_user, 3, state: FactoryGirl.create(:oh), district: FactoryGirl.create(:district))
      bills = FactoryGirl.create_list(:bill, 12).each do |bill|
        users.each do |user|
          bill.vote_on(user.id, [:aye, :nay, :abstain, :present][rand(4)]) if rand > 0.2
        end
      end
      most_popular_bills = Bill.most_popular.to_a
      most_popular_bills.size.should eq(10)
      most_popular_bills.first.vote_count.should be > most_popular_bills.last.vote_count
    end

  end # basic properties of a bill context

  context "can work with external data" do

    it "should be able to pull in a bill and update it" do
      bill_name = "h3605"
      b = Bill.find_or_create_by(:title => bill_name, :govtrack_name => bill_name)
      b.update_bill
      b.titles[0].last.should eql("Global Online Freedom Act of 2011")
      b.should be_valid
    end

    it "should be able to get an associated roll call" do
      # bills are named as data/us/CCC/rolls/[hs]SSSS-NNN.xml.
      # ccc= congress number
      f = File.new("#{DATA_PATH}/rolls/h2011-9.xml", 'r')
      feed = Feedzirra::Parser::RollCall.parse(f)
      feed.bill_type.should eq('hr')
      feed.chamber.should eq('house')
      feed.bill_number.should eq("26")
      feed.roll_call.count.should eq(434)
    end

    it "should be able to embed a role" do
      # govtrack_id = "#{feed.bill_type.first}#{feed.congress}-#{feed.bill_number}"
      # h2009-11.xml h2011-28.xml h2011-40.xml h2011-9.xml
      b = FactoryGirl.create(:bill)
      b.pull_in_roll("h2009-11.xml")
    end

    it "should be able to get roll-counts inside all relevant bills " do
      pending
      # update_rolls should bring in the latest votes for all
      #@house_bill_with_roll_count.members_tally.should eq({:ayes => 236, :nays => 182, :abstains => 16, :presents => 0})
      ## we should also be able to get a member's result on a specific bill
      #member = @house_bill_with_roll_count.member_votes.first.legislator
      #puts member.full_name
      #assert_equal(:aye, @house_bill_with_roll_count.find_member_vote(member))
      #assert_equal(:nay, @house_bill_with_roll_count.find_member_vote(Legislator.where(govtrack_id: 400436).first))
      #assert_equal(:abstain, @house_bill_with_roll_count.find_member_vote(Legislator.where(govtrack_id: 412445).first))
    end

  end

  context "when I interface with legislators a Bill" do

    it "should be able to show the house representatives vote if the bill is a hr" do
      pending "until i get legislators set up"
      # given that I am @user1 and I want to view hr26, I should see my specific rep's vote on this bill
      b = FactoryGirl.create(:bill, )
      #rep_vote = @user1.reps_vote_on(@house_bill_with_roll_count)
      #assert_equal({:rep => "Gary Ackerman", :vote => :nay}, rep_vote, "representative's vote does not match")
    end

    it "should be able to show both senators votes if the bill is a sr" do
      pending "until i get legislators set up"
      #senator_votes = @user1.senators_vote_on(@senate_bill_with_roll_count)
      #assert_equal :nay, senator_votes.first[:vote], "senator's vote does not match"
    end

    it "should be able to add a sponsor to a bill" do
      pending
=begin
   b = Bill.new
   b.title = Faker::Company.name
   b.govtrack_name = "s182" #fake
   b.save_sponsor(400032)
   assert_equal "Marsha Blackburn", b.sponsor.full_name
=end
    end

    it "save cosponsors for bill" do
      pending
=begin
   Bill.destroy_all
   b = Bill.new(
       :congress => 112,
       :bill_type => 's',
       :bill_number => 368,
       :title => 's368',
       :govtrack_name => 's368'
   )
   cosponsor_ids = ["412411", "400626", "400224", "412284", "400570", "400206", "400209", "400068", "400288", "412271", "412218", "400141", "412480", "412469", "400277", "400367", "412397", "412309", "400411", "412283", "412434", "400342", "400010", "400057", "400260", "412487", "412436", "400348", "412478", "400633", "400656", "400115"]
   b.save_cosponsors(cosponsor_ids)
   assert_equal 32, b.cosponsors.to_a.count
=end
    end

  end

  context "interfaces with users and " do

    it "should let a user vote on the bill" do
      b = FactoryGirl.create(:bill)
      u = FactoryGirl.create(:user)
      b.vote_on(u.id, :aye)
    end

    it "should tell you how a user voted on a bill" do
      b = FactoryGirl.create(:bill)
      u = FactoryGirl.create(:user)
      b.vote_on(u.id, :aye)
      b.voted_on?(u).should eql(:aye)
    end

    it "should get the overall users vote on a bill" do
      b = FactoryGirl.create(:bill)
      pg = FactoryGirl.create(:common)
      state = FactoryGirl.create(:oh)
      district = FactoryGirl.create(:district)
      users = FactoryGirl.create_list(:random_user, 4, {joined_groups: [pg], state: state, district: district})
      b.vote_on(users[0].id, :aye)
      b.vote_on(users[1].id, :nay)
      b.vote_on(users[2].id, :aye)
      b.vote_on(users[3].id, :abstain)
      tally = b.get_overall_users_vote
      tally.should == {:ayes => 2, :nays => 1, :abstains => 1, :presents => 0}
    end

    it "should record the group when a user votes on a bill" do
      Bill.delete_all
      PolcoGroup.delete_all
      b = FactoryGirl.create(:bill)
      u = FactoryGirl.create(:user)
      b.vote_on(u.id, :aye)
      b.votes.size.should eql(4)
      b.votes.all.map { |v| puts "#{v.polco_group.name}" }
      groups = b.votes.map { |v| v.polco_group.name }
      groups.should include('common')
    end

    it "should show what the current users vote is on a specific bill" do
      b = FactoryGirl.create(:bill)
      u = FactoryGirl.create(:user)
      b.vote_on(u.id, :aye)
      b.users_vote(u).should eql(:aye)
    end

    it "should show the votes for a specific district that a user belongs to" do
      #PolcoGroup.destroy_all
      Vote.destroy_all
      pg = FactoryGirl.create(:common)
      cg = FactoryGirl.create(:polco_group)
      b = FactoryGirl.create(:bill)
      dg = FactoryGirl.create(:district)
      user1, user2, user3, user4 = FactoryGirl.create_list(:random_user, 4, {joined_groups: [pg, cg], state: FactoryGirl.create(:oh)})
      user1.district = PolcoGroup.create(name: "test group"); user1.save
      user2.district = dg; user2.save
      user3.district = dg; user3.save
      user4.district = dg; user4.save
      b.vote_on(user1.id, :aye) # not in district
      b.vote_on(user2.id, :nay)
      b.vote_on(user3.id, :abstain)
      b.vote_on(user4.id, :aye)
      user3.district.get_tally.should eql({:ayes => 1, :nays => 1, :abstains => 1, :presents => 0})
    end

    it "should be able to show votes for a specific state that a user belongs to" do
      pg = FactoryGirl.create(:common)
      cg = FactoryGirl.create(:polco_group)
      b = FactoryGirl.create(:bill)
      oh = FactoryGirl.create(:oh)
      user1, user2, user3, user4 = FactoryGirl.create_list(:random_user, 4, {joined_groups: [pg, cg], district: FactoryGirl.create(:district), state: oh})
      user1.state = PolcoGroup.create(type: :state, name: "CA"); user1.save
      b.vote_on(user1.id, :aye)
      b.vote_on(user2.id, :nay)
      b.vote_on(user3.id, :nay)
      b.vote_on(user4.id, :aye)
      user2.state.get_tally.should eql({:ayes => 1, :nays => 2, :abstains => 0, :presents => 0})
    end

    it "should silently block a user from voting twice on a bill" do
      b = FactoryGirl.create(:bill)
      u = FactoryGirl.create(:user)
      b.vote_on(u.id, :aye)
      b.vote_on(u.id, :aye)
      puts u.joined_groups.map(&:name)
      b.votes.size.should eql(u.joined_groups.size + 2)
    end

    it "should reject a value for vote other than :aye, :nay or :abstain" do
      b = FactoryGirl.create(:bill)
      v1 = b.votes.new
      v1.user = FactoryGirl.create(:user)
      v1.polco_group = FactoryGirl.create(:polco_group)
      v1.value = :happy
      v1.should_not be_valid
      #assert_equal "You can only vote yes, no or abstain", v1.errors.messages[:value].first
    end

  end

=begin
 test "should be able to get the tallies for all of a user's custom groups (followed and joined)" do
   # so we are logged in as user1 on @house_bill page
   # we want to see all of our custom groups (joined groups and followed groups), with an associated tally
   # so we can put something like this in our views
   #@user1.joined_groups
   #@user1.followed_groups
   puts "********************"
   puts " starting this test "
   puts "********************"
   puts "user groups at start:"
   puts @user1.joined_groups.map(&:name)
   puts @user1.joined_groups.size
   @user1.vote_on(@house_bill, :aye) # follows va05
   puts "new size #{@user1.joined_groups.size}"
   @user2.vote_on(@house_bill, :nay)
   @user3.vote_on(@house_bill, :abstain) # joined va05
   @user4.vote_on(@house_bill, :present)
   puts @user1.joined_groups.map(&:name)
   puts "before !! #{@user1.joined_groups.count}"
   joined_groups = @user1.joined_groups_tallies(@house_bill)
   puts joined_groups.inspect
   followed_groups = @user1.followed_groups_tallies(@house_bill)
   assert_equal 4, joined_groups.count
   assert_equal "Dan Cole", joined_groups.first[:name]
   assert_equal({:ayes => 1, :nays => 1, :abstains => 1, :presents => 1}, joined_groups.first[:tally])
   assert_equal 2, followed_groups.count
   assert_equal "VA".to_s, followed_groups.first[:name].to_s
   assert_equal({:ayes => 0, :nays => 0, :abstains => 1, :presents => 1}, followed_groups.first[:tally])
 end



 test "should get most recent roll called bill and exclude bills from this list that have not been roll-called" do
   #Bill.house_roll_called_bills
   #Bill.house_roll_called_bills.last.member_votes.count
 end

 test "should be able to report its activity appropriately" do
   assert_true @house_bill_with_roll_count.activity?
   assert_false @house_bill.activity?
 end
=end

end
