class Users < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :color, :string
    add_column :users, :logo, :string
  end
  
end
