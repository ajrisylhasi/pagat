class AddPushimToWorks < ActiveRecord::Migration[6.0]
  def change
    add_column :works, :pushim, :boolean
  end
end
