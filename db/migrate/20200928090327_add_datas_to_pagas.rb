class AddDatasToPagas < ActiveRecord::Migration[6.0]
  def change
    add_column :pagas, :date_from, :date
    add_column :pagas, :date_to, :date
  end
end
