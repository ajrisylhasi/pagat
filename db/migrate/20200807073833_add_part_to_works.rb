class AddPartToWorks < ActiveRecord::Migration[6.0]
  def change
    add_column :works, :part_group, :boolean
  end
end
