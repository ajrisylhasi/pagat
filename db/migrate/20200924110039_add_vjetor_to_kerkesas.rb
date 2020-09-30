class AddVjetorToKerkesas < ActiveRecord::Migration[6.0]
  def change
    add_column :kerkesas, :data_fillimit, :date
    add_column :kerkesas, :data_mbarimit, :date
    add_column :kerkesas, :numri_diteve, :integer
  end
end
