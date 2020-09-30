class AddBreakToWorks < ActiveRecord::Migration[6.0]
  def change
    add_column :works, :break, :float
  end
end
