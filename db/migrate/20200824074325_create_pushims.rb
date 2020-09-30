class CreatePushims < ActiveRecord::Migration[6.0]
  def change
    create_table :pushims do |t|
      t.date :date
      t.text :komenti

      t.timestamps
    end
  end
end
