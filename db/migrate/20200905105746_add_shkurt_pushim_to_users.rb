class AddShkurtPushimToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :shkurt_pushim, :boolean
  end
end
