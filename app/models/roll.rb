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

  embedded_in :bill
  field :legislator_votes, :type => Hash

  # [:aye, :nay, :abstain, :present]
  VAL = {'+' => :aye, '-' => :nay, 'P' => :present, '0' => :abstain}

  def embed_legislator_votes(roll_call)
    votes_hash = Hash.new
    roll_call.each do |v|
      if l = Legislator.where(govtrack_id: v.member_id).first
        votes_hash[l.id.to_s] = VAL[v.member_vote.to_s]
        #b.member_votes << MemberVote.new(:value => Bill.get_value(v.member_vote), :legislator => l)
      else
        raise "legislator #{v.member_id} not found"
      end
    end
    self.legislator_votes = votes_hash
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

end
