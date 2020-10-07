class AddPlaceToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :place, :string
  end
end
