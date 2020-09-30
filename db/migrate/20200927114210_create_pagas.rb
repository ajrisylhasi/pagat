class CreatePagas < ActiveRecord::Migration[6.0]
  def change
    create_table :pagas do |t|
      t.references :user, null: false, foreign_key: true
      t.references :deklarim, null: false, foreign_key: true

      t.timestamps
    end
  end
end
