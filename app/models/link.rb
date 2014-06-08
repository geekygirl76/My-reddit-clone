class Link < ActiveRecord::Base
  validates :url, :title, :body, :user_id, :sub_id, presence: true

  belongs_to :sub, inverse_of: :links

  belongs_to :user, inverse_of: :links


  has_many :comments, inverse_of: :link


  def top_level_comments
    comments.select { |comment| comment.parent_comment_id.nil? }
  end

  def comments_hash
    hash = Hash.new { |hash, key| hash[key] = [] }

    self.comments.each do |comment|
      hash[comment.parent_comment_id] << comment
    end

    hash
  end
end
