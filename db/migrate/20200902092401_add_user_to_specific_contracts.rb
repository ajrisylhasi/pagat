class AddUserToSpecificContracts < ActiveRecord::Migration[6.0]
  def change
    add_reference :specific_contracts, :user, null: false, foreign_key: true
  end
end
