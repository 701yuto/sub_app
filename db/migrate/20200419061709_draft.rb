class Draft < ActiveRecord::Migration[5.2]
  def change
    add_column :drafts, :order, :integer
    add_column :drafts, :position, :integer
  end
end
