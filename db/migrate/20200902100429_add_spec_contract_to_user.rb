class AddSpecContractToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :spec_contract, :boolean
  end
end
