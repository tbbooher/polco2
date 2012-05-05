class Roll
  include Mongoid::Document
  field :result, :type => String
  field :required, :type => String
  field :type, :type => String
  field :question, :type => String
  field :category, :type => String
  field :ayes, :type => Integer
  field :nays, :type => Integer
  field :nv, :type => Integer
  field :present, :type => Integer
  field :session, :type => Integer
  field :year, :type => Integer
  field :datetime, :type => Time
  field :updated, :type => Time
  field :where, :type => String
end
