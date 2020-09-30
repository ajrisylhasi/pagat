class CreateKerkesas < ActiveRecord::Migration[6.0]
  def change
    create_table :kerkesas do |t|
      t.date :data_punes
      t.string :lloji_pushimit
      t.string :ditet_pushimit

      t.timestamps
    end
  end
end
