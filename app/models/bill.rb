class Bill
  include Mongoid::Document

  # needed for comments
  #field :interpreter,                             :default => :markdown
  field :allow_comments,        :type => Boolean, :default => true
  field :allow_public_comments, :type => Boolean, :default => true

  # initial fields
  field :congress, :type => Integer
  field :bill_number, :type => Integer
  field :bill_type, :type => String
  index :bill_type

  field :last_updated, :type => Date
  # update fields from GovTrackBill

  field :bill_state, :type => String #
  field :introduced_date, :type => Date #
  field :title, :type => String
  index :title
  field :titles, :type => Array #
  field :summary, :type => String #
  field :bill_actions, :type => Array #

  index :created_at

  # things i get with an extra call
  field :bill_html, :type => String

  # things i calculate
  field :ident, :type => String
  field :cosponsors_count, :type => Integer
  field :govtrack_id, :type => String
  # add index
  field :govtrack_name, :type => String

  index :govtrack_name

  field :summary_word_count, :type => Integer
  field :text_word_count, :type => Integer

  field :text_updated_on, :type => Date
  field :hidden, :type => Boolean

  # roll call results
  field :roll_time, :type => DateTime
  index :roll_time

  # TODO -- this is recorded in votes -- can't we delete?
  field :ayes, :type => Integer
  field :nays, :type => Integer
  field :abstains, :type => Integer
  field :presents, :type => Integer

  scope :house_bills, where(title: /^h/)
  scope :senate_bills, where(title: /^s/)
  scope :introduced_house_bills, where(title: /^h/).and(bill_state: /^INTRODUCED|REPORTED|REFERRED$/)
  scope :introduced_senate_bills, where(title: /^s/).and(bill_state: /^INTRODUCED|REPORTED|REFERRED$/)
  #scope :rolled_house_bills, where(title: /^h/).excludes(bill_state: /^INTRODUCED|REPORTED|REFERRED$/)
  #scope :rolled_senate_bills, where(title: /^s/).excludes(bill_state: /^INTRODUCED|REPORTED|REFERRED$/)

end
