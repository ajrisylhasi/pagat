class AddGroupToWorks < ActiveRecord::Migration[6.0]
  def change
    add_reference :works, :group, null: true, foreign_key: true
  end
end
