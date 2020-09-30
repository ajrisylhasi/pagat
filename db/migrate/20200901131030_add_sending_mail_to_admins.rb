class AddSendingMailToAdmins < ActiveRecord::Migration[6.0]
  def change
    add_column :admins, :sending_mail, :string
  end
end
