class Paga < ApplicationRecord
  belongs_to :user
  belongs_to :deklarim

  before_save :default

  def default
  	self.kontributi_sup ||= 0
  	self.pune_primare ||= "PO"
  	self.perfsh_kont ||= "PO"
  	self.apli_tat ||= "PO"
  end
  
end
