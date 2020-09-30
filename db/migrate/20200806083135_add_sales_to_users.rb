class AddSalesToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :sales, :float
  end
end
