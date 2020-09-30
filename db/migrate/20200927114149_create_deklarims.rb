class CreateDeklarims < ActiveRecord::Migration[6.0]
  def change
    create_table :deklarims do |t|
      t.string :muaji
      t.timestamps
    end
  end
end