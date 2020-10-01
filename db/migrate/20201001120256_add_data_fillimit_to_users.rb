class AddDataFillimitToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :data_fillimit, :date
  end
end
