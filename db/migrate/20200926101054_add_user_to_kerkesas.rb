class AddUserToKerkesas < ActiveRecord::Migration[6.0]
  def change
    add_reference :kerkesas, :user, null: false, foreign_key: true
  end
end
