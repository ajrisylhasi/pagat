class AddKushToLogs < ActiveRecord::Migration[6.0]
  def change
    add_column :logs, :kush, :string
  end
end
