class AddMissToWorks < ActiveRecord::Migration[6.0]
  def change
    add_column :works, :miss, :float
  end
end
