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

  #has_and_belongs_to_many :senators, :class_name => "Legislator", :inverse_of => :state_constituents
  #belongs_to :representative, :class_name => "Legislator", :inverse_of => :district_constituents

  before_create :assign_default_group

  def us_state
    self.state.name
  end

  def district_name
    self.district.name
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

