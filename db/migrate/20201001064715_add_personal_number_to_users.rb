class AddPersonalNumberToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :personal_number, :string
  end
end
