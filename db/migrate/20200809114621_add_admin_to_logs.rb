class AddAdminToLogs < ActiveRecord::Migration[6.0]
  def change
    add_reference :logs, :admin, foreign_key: true
  end
end
