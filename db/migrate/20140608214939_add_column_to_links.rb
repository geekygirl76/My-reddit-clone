class AddColumnToLinks < ActiveRecord::Migration
  def change
    add_column :links, :vote_value, :integer
  end
end
