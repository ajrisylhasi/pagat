class AddPushimesToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :pushimi_vjetor, :integer
    add_column :users, :pushimi_mjekesor, :integer
  end
end
