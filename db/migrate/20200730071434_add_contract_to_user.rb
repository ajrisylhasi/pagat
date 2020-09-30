class AddContractToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :contract, :integer
  end
end
