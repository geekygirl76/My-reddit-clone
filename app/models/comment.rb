class Comment < ActiveRecord::Base
  validates :content, :user_id, :link_id, presence: true

  belongs_to :user, inverse_of: :comments

  belongs_to :link, inverse_of: :comments

  has_many :child_comments, class_name: "Comment", foreign_key: :parent_comment_id, primary_key: :id
  belongs_to :parent_comments, class_name: "Comment", foreign_key: :parent_comment_id, primary_key: :id



end
