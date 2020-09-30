class User < ApplicationRecord
	has_many :works, dependent: :destroy
	has_many :groups, dependent: :destroy
  has_many :kerkesas, dependent: :destroy
	validates :idnum, presence: true, uniqueness: {message: "- Perdoruesi me kete ID ekziston"}
	before_save :default

  serialize :pushimet, Array

  has_one :specific_contract, dependent: :destroy
	accepts_nested_attributes_for :works, allow_destroy: true
		
	def default
    self.shkurt_pushim ||= false
    self.spec_contract ||= false
		self.contract ||= 40
		self.salary ||= 400
		self.salary_type ||= "Primary"
		self.sales ||= 0
	end

  def idnum_str
    self.idnum.scan(/\d/).join('').to_i
  end

  def first_name
    return self.name.split(" ")[0]
  end
  
	def ora
    if self.spec_contract 
      con = self.specific_contract.total
    else
	    con = self.contract
    end
    if con == 40 
      return self.salary/168
    elsif con == 30
      return self.salary/125
    elsif con == 20
      return self.salary/84
    else
      return self.salary/(con*4.2)
    end
  end

  def ora_e
  	return self.ora * 1.3 
  end

  def ora_p
  	return self.ora * 1.5
  end

  def ditet_pushim
    str = []
    i = 0
    loop do  
      if i == 0 && pushimet[i] == "true"
        str << "E Hënë"
      elsif i == 1 && pushimet[i] == "true"
        str << "E Martë"
      elsif i == 2 && pushimet[i] == "true"
        str << "E Mërkurë"
      elsif i == 3 && pushimet[i] == "true"
        str << "E Enjte"
      elsif i == 4 && pushimet[i] == "true"
        str << "E Premte"
      elsif i == 5 && pushimet[i] == "true"
        str << "E Shtunë"
      elsif i == 6 && pushimet[i] == "true"
        str << "E Diel"
      end
      i+=1
      break if i == 7
    end
    return str
  end
end
