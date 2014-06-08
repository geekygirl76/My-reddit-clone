class CreateLinkComments < ActiveRecord::Migration
  def change
    create_table :link_comments do |t|
      t.integer :link_id
      t.timestamps :comment_id
    end
  end
end
