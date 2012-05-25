class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :provider, :type => String
  field :uid, :type => String
  field :name, :type => String
  field :email, :type => String
  attr_accessible :provider, :uid, :name, :email

  has_many :custom_groups, :class_name => "PolcoGroup", :inverse_of => :owner
  has_many :votes

  belongs_to :district, class_name: "PolcoGroup", inverse_of: :constituents
  belongs_to :state, class_name: "PolcoGroup", inverse_of: :state_constituents

  has_and_belongs_to_many :joined_groups, :class_name => "PolcoGroup", :inverse_of => :members

  has_and_belongs_to_many :followed_groups, :class_name => "PolcoGroup", :inverse_of => :followers

  # a user can only join or follow a group once
  validates :joined_group_ids, :allow_blank => true, :uniqueness => true
  validates :followed_group_ids, :allow_blank => true, :uniqueness => true

  has_and_belongs_to_many :senators, :class_name => "Legislator", :inverse_of => :state_constituents
  belongs_to :representative, :class_name => "Legislator", :inverse_of => :district_constituents

  before_create :assign_default_group

  def bills_voted_on(chamber)
    Bill.any_in(_id: Vote.where(user_id: self.id).and(chamber: chamber).map(&:bill_id)).desc(:introduced_date)
  end

  def bills_not_voted_on(chamber)
    ids = Vote.where(user_id: self.id).map{|v| v.bill.id }
    if chamber == :house
      Bill.where(title: /^h/).not_in(_id: ids).desc(:vote_count)
    else
      Bill.where(title: /^s/).not_in(_id: ids).desc(:vote_count)
    end
    #Bill.find(Bill.all.map(&:id)-Vote.where(user_id: self.id).map{|v| v.bill.id })
  end

  def find_10_bills_not_voted_on
    ids = Vote.where(user_id: self.id).map{|v| v.bill.id }
    Bill.not_in(_id: ids).limit(10)
  end

  def us_state
    self.state.name if self.state
  end

  def reps_vote_on(house_bill)
    if house_bill.rolled?
      if leg = self.representative
        house_bill.find_member_vote(leg).to_s
      end
    else
      "Vote has not yet occured"
    end
  end

  def senators_vote_on(b)
    unless self.senators.empty?
      votes = []
      self.senators.each do |senator|
        if vote = LegislatorVote.where(legislator_id: senator.id).and(bill_id: b.id).first
           votes.push({name: vote.full_name, value: vote.value})
        end
      end
      votes
    end
  end

  def load_test_members
    d = PolcoGroup.districts.where(name: 'C005').first
    s = PolcoGroup.states.where(name: 'CO').first
    self.district = d
    self.state = s
    self.senators << Legislator.senators.where(state: 'CO').all.to_a
    self.representative = d.the_rep
    self.save
  end

  def add_members(junior_senator, senior_senator, representative, district, us_state)
    self.senators.push(junior_senator)
    self.senators.push(senior_senator)
    self.representative = representative
    self.district = district
    self.add_baseline_groups(us_state, district)
    self.role = :registered # 7 = registered (or 6?)
    self.save!
  end

  def district_name
    self.district.name if self.district
  end

  def record_vote_for_state_and_district(bill_id, value)
    if self.district.nil? || self.state.nil?
      raise "#{self.name} must have an assigned state and district"
    else
      [self.district, self.state].each do |polco_group|
        Vote.create!(user_id: self.id, bill_id: bill_id, value: value, polco_group_id: polco_group.id)
      end
    end
  end

  def assign_default_group
    puts "assigning default group"
    if common_group = PolcoGroup.find_or_create_by(name: "common",type: :common)
      self.joined_group_ids << common_group.id
    else
      raise "common group does not exist and can not be created"
    end
    # temp . ..  we assign state and district
    self.state = PolcoGroup.states.first
    # TODO remove this !!!!
    self.district = PolcoGroup.districts.first unless self.district
    self.representative = self.district.the_rep unless self.representative
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
         user.name = auth['info']['name'] || ""
         user.email = auth['info']['email'] || ""
      end
    end
  end

end

