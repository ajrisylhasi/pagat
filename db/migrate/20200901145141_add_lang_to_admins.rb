class AddLangToAdmins < ActiveRecord::Migration[6.0]
  def change
    add_column :admins, :lang, :string
  end
end
