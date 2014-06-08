class LinkComment < ActiveRecord::Base
  validates :link_id, :comment_id, presence: true
  belongs_to :link, inverse_of: :link_comments
  belongs_to :comment, inverse_of: :link_comments

end
