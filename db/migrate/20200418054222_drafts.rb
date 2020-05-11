class Drafts < ActiveRecord::Migration[5.2]
  def change
    add_column :drafts, :room_id, :integer
  end
end
