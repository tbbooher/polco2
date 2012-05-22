class Roll
  include Mongoid::Document

  field :chamber, :type => String
  field :session, :type => Integer #
  field :result, :type => String #
  field :required, :type => String #
  field :type, :type => String #
  field :bill_type, :type => String #
  field :the_question, :type => String #
  field :bill_category, :type => String #
  # votes
  field :aye, :type => Integer   #
  field :nay, :type => Integer   #
  field :nv, :type => Integer     #
  field :present, :type => Integer   #
  field :year, :type => Integer     #
  field :congress, :type => String  #
  #
  field :original_time, :type => Time    #
  field :updated_time, :type => Time     #
  # still here for speed . . . (might delete)
  #field :legislator_votes, :type => Hash

  # associations
  belongs_to :bill
  has_many :legislator_votes

  # [:aye, :nay, :abstain, :present]
  VAL = {'+' => :aye, '-' => :nay, 'P' => :present, '0' => :abstain}

  def embed_legislator_votes(roll_call, bill)
    votes_hash = Hash.new
    roll_call.each do |v|
      if l = Legislator.where(govtrack_id: v.member_id).first
        LegislatorVote.create(bill_id: bill.id, legislator_id: l.id, value: VAL[v.member_vote.to_s], roll_id: self.id)
        # votes_hash[l.id.to_s] = VAL[v.member_vote.to_s]
      else
        raise "legislator #{v.member_id} not found"
      end
    end
    #self.legislator_votes = votes_hash
  end

  def tally
    #field :aye, :type => Integer   #
    #field :nay, :type => Integer   #
    #field :nv, :type => Integer     #
    #field :present, :type => Integer   #
    {:ayes => self.aye, :nays => self.nay, :abstains => self.nv, :presents => self.present}
  end

  def record_legislator_votes
    # the purpose of this is to build a table that links legislators to votes
    self.legislator_votes.each do |vote|
      LegislatorVote.create(bill_id: self.bill.id, legislator_id: vote.first, value: vote.last)
    end
  end

  def self.pull_in_roll(roll_name)
    # this adds a roll to an existing bill, but the govtrack ids must match
    f = File.new("#{DATA_PATH}/rolls/#{roll_name}", 'r')
    feed = Feedzirra::Parser::RollCall.parse(f)
    # check to make sure this is the same bill
    govtrack_id = "#{feed.bill_type.first}#{feed.congress}-#{feed.bill_number}"
    bill = Bill.where(govtrack_id: govtrack_id).first
    pull_in_role_feed(feed, govtrack_id, bill)
  end

  def self.pull_in_role_feed(feed, govtrack_id, bill)
    if bill.govtrack_id == govtrack_id
      bill.roll_time = Date.parse(feed.updated_time)
      roll = Roll.new
      roll.chamber = feed.chamber
      roll.session = feed.session
      roll.result = feed.result
      roll.required = feed.required
      roll.type = feed.type
      roll.bill_type = feed.bill_type
      roll.the_question = feed.the_question
      roll.bill_category = feed.bill_category
      roll.aye = feed.aye
      roll.nay = feed.nay
      roll.nv = feed.nv
      roll.present = feed.present
      roll.year = feed.year
      roll.congress = feed.congress
      roll.original_time = feed.original_time
      roll.updated_time = feed.updated_time
      roll.embed_legislator_votes(feed.roll_call, bill)
      if roll.valid?
        bill.rolls << roll
        roll.save
        bill.save
        roll
      else
        raise "roll not valid"
      end
    else
      raise "the roll for #{govtrack_id} doesn't match this bill: #{self.govtrack_id}"
    end
  end


end
