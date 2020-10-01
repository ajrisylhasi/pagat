class AddStuffToPagas < ActiveRecord::Migration[6.0]
  def change
    add_column :pagas, :paga_bruto, :float
    add_column :pagas, :kontributi_pension, :float
    add_column :pagas, :kontributi_sup, :float
    add_column :pagas, :pune_primare, :string
    add_column :pagas, :perfsh_kont, :string
    add_column :pagas, :apli_tat, :string
  end
end
