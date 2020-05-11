class Rooms < ActiveRecord::Migration[5.2]
  def change
      remove_column :rooms, :next, :string
      add_column :rooms, :next, :integer
  end
end
