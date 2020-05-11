class CreateDrafts < ActiveRecord::Migration[5.2]
  def change
    create_table :drafts do |t|
      t.integer :user_id
      t.string :member_name

      t.timestamps
    end
  end
end
