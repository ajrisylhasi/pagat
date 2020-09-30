class AddUserToWorks < ActiveRecord::Migration[6.0]
  def change
    add_reference :works, :user, null: false, foreign_key: true
  end
end
