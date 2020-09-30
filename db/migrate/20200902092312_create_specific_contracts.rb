class CreateSpecificContracts < ActiveRecord::Migration[6.0]
  def change
    create_table :specific_contracts do |t|
      t.integer :monday
      t.integer :tuesday
      t.integer :wednesday
      t.integer :thursday
      t.integer :friday
      t.integer :saturday
      t.integer :sunday

      t.timestamps
    end
  end
end
