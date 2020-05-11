class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.integer :room_id
      t.integer :number_of_members
      t.integer :number_of_players
      t.integer :order
      t.integer :user1
      t.integer :user2
      t.integer :user3
      t.integer :user4

      t.timestamps
    end
  end
end
