class AddFileToKerkesas < ActiveRecord::Migration[6.0]
  def change
    add_column :kerkesas, :file, :text
  end
end
