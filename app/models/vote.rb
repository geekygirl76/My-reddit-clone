class Vote < ActiveRecord::Base
  validates :value, :user_id, :votable_id, :votable_type, presence: true
  belongs_to :votable, polymorphic: true
end
