class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.integer :room_id
      t.string :name
      t.integer :color
      t.string :select
      t.text :memo

      t.timestamps
    end
  end
end
