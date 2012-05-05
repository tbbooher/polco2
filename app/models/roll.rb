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
  field :ayes, :type => Integer   #
  field :nays, :type => Integer   #
  field :nv, :type => Integer     #
  field :present, :type => Integer   #
  field :year, :type => Integer     #
  field :congress, :type => String  #
  #
  field :original_time, :type => Time    #
  field :updated_time, :type => Time     #

  embedded_in :bill
end
