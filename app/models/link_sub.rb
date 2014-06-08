class LinkSub < ActiveRecord::Base
  validates :link_id, :sub_id, presence: true

  belongs_to :link, inverse_of: :link_subs
  belongs_to :sub, inverse_of: :link_subs
end
