module VotingLogic

  # this module contains everything related to bills and voting
  # since all voting happens on bills, we want to put all voting logic here

  def vote_on(user, value)
    unless self.voted_on?(user)
      #ids = user.joined_group_ids
      #ids.push(user.state.id)
      #ids.push(user.district.id)
      #Vote.create(value: value, user_id: user.id, polco_group_ids: ids.uniq, bill_id: self.id)
      v = Vote.new
      v.value = value
      v.user = user
      v.polco_groups << user.joined_groups
      v.polco_groups << user.state
      v.polco_groups << user.district
      v.bill = self
      v.save
      self.inc(:vote_count,1)
    else
      Rails.logger.warn "already voted on #{user.name} with #{self.bill_title}"
      puts "already voted on"
      false
    end
  end

  def vote_on_old(user_id, value)
    user = User.find(user_id)
    # test to make sure the user is a member of a group
    my_groups = user.joined_groups
    puts "voting"
    puts "joined group size is #{my_groups.size}"
    unless my_groups.empty?
      unless self.voted_on?(user)
        user.record_vote_for_state_and_district(self.id, value)
        self.inc(:vote_count,1)
        my_groups.each_with_index do |g, i|
          puts "processing #{value} for #{self} name: #{g.name} bill: #{self.title} index #{i}"
          unless Vote.create!(:value => value, :user => user, :polco_group => g, :bill => self)
            raise "vote not valid"
          else
            # increase vote count
            puts "created vote #{value} for group #{g.name}"
          end
        end
      else
        Rails.logger.warn "already voted on"
        puts "all ready voted on"
        false
        #raise "already voted on"
      end
      #bill.save!
    else
      raise "no joined_groups for this user"
    end
  end

  def members_tally
    # TODO needs updated
    # this answers: how did members vote on this bill?
    process_votes(self.member_votes)
  end

  def get_overall_users_vote
    process_votes(self.votes)
  end

  def find_member_vote(member)
    if self.member_votes
      if vote = self.member_votes.where(legislator_id: member.id).first
        vote.value
      else
        ""
      end
    else
      "no member votes to search"
    end
  end

  def voted_on?(user)
    if vote = user.votes.where(bill_id: self.id).first
      vote.value
    end
  end

  def users_vote(user)
    if vote = self.votes.all.select { |v| v.user = user }.first
      vote.value
    else
      "none"
    end
  end

end