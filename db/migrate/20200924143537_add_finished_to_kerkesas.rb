class AddFinishedToKerkesas < ActiveRecord::Migration[6.0]
  def change
    add_column :kerkesas, :finished, :boolean
  end
end
