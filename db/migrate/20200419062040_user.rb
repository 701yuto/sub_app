class User < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :select_beta, :string
  end
end
