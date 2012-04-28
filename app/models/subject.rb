class Subject
  include Mongoid::Document
  field :name, :type => String
  index :name

  has_and_belongs_to_many :bills
  validates_uniqueness_of :name

end
