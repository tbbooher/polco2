class Comment
  include Mongoid::Document
  # meant to match akismet
  field :author, type: String
  field :author_email, type: String
  field :comment_type, type: String
  field :content, type: String
  field :user_ip, type: String

  belongs_to :commentable, polymorphic: true

end
