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
    self.data_fillimit ||= Date.new(Date.today.year, 1, 1)
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

  def pushimi_vjetor
    data_sot = Date.today
    data = self.data_fillimit
    pushimi_kaluar = 0.0
    data_limit = data
    if data.year < data_sot.year
      unless Date.today.month > 6
        pushimi_kaluar = pushimi_vjetor_kaluar
      end
      data = Date.new(data.year, 1, 1)
      data_limit = Date.new(data_sot.year, 6, 30)
    end
    muajt = (data.month..Date.today.month).count
    pushimi = muajt * 1.5
    minus = 0
    self.kerkesas.each do |k|
      if k.data_fillimit >= data_limit
        if k.finished && k.lloji_pushimit == "Pushim Vjetor"
          minus += k.numri_diteve
        end
      end
    end
    pushimi = pushimi - minus
    return pushimi + pushimi_kaluar
  end

  def pushimi_vjetor_sivjet
    data_sot = Date.today
    data = self.data_fillimit
    pushimi_kaluar = 0.0
    data_limit = data
    if data.year < data_sot.year
      data = Date.new(data.year, 1, 1)
      data_limit = Date.new(data_sot.year, 6, 30)
    end
    muajt = (data.month..Date.today.month).count
    pushimi = muajt * 1.5
    minus = 0
    self.kerkesas.each do |k|
      if k.data_fillimit >= data_limit
        if k.finished && k.lloji_pushimit == "Pushim Vjetor"
          minus += k.numri_diteve
        end
      end
    end
    pushimi = pushimi - minus
    return pushimi
  end

  def pushimi_vjetor_kaluar
    data = self.data_fillimit
    if (data.year + 1) < Date.today.year
      data = Date.new(Date.today.year - 1, 1, 1)
    end
    data_funit = Date.new(data.year, 12, 1)
    data_limit = Date.new(data.year+1, 6, 30)
    muajt = (data.month..data_funit.month).count
    pushimi = muajt * 1.5
    minus_kaluar = 0
    minus = 0
    self.kerkesas.each do |k|
      if k.data_mbarimit > data_limit
        if k.data_fillimit < data_limit && k.data_fillimit > data
          if k.finished && k.lloji_pushimit == "Pushim Mjekesor"
            minus_kaluar = k.numri_diteve_spec(data_limit)
          else
            next
          end
        else
          next
        end
      elsif k.data_mbarimit <= data_limit
        if k.data_fillimit > data_fillimit
          if k.finished && k.lloji_pushimit == "Pushim Mjekesor"
            minus_kaluar = k.numri_diteve
          else
            next
          end
        end
      else
        next
      end
    end
    return pushimi - minus_kaluar
  end

  def pushimi_mjekesor
    data_sot = Date.today
    data = self.data_fillimit
    pushimi_kaluar = 0.0
    data_limit = data
    if data.year < data_sot.year
      unless Date.today.month > 6
        pushimi_kaluar = pushimi_mjekesor_kaluar
      end
      data = Date.new(data.year, 1, 1)
      data_limit = Date.new(data_sot.year, 6, 30)
    end
    muajt = (data.month..Date.today.month).count
    pushimi = muajt * 1.5
    minus = 0
    self.kerkesas.each do |k|
      if k.data_fillimit >= data_limit
        if k.finished && k.lloji_pushimit == "Pushim Mjekesor"
          minus += k.numri_diteve
        end
      end
    end
    pushimi = pushimi - minus
    return pushimi + pushimi_kaluar
  end

  def pushimi_mjekesor_sivjet
    data_sot = Date.today
    data = self.data_fillimit
    pushimi_kaluar = 0.0
    data_limit = data
    if data.year < data_sot.year
      data = Date.new(data.year, 1, 1)
      data_limit = Date.new(data_sot.year, 6, 30)
    end
    muajt = (data.month..Date.today.month).count
    pushimi = muajt * 1.5
    minus = 0
    self.kerkesas.each do |k|
      if k.data_fillimit >= data_limit
        if k.finished && k.lloji_pushimit == "Pushim Vjetor"
          minus += k.numri_diteve
        end
      end
    end
    pushimi = pushimi - minus
    return pushimi
  end

  def pushimi_mjekesor_kaluar
    data = self.data_fillimit
    if (data.year + 1) < Date.today.year
      data = Date.new(Date.today.year - 1, 1, 1)
    end
    data_funit = Date.new(data.year, 12, 1)
    data_limit = Date.new(data.year+1, 6, 30)
    muajt = (data.month..data_funit.month).count
    pushimi = muajt * 1.5
    minus_kaluar = 0
    minus = 0
    self.kerkesas.each do |k|
      if k.data_mbarimit > data_limit
        if k.data_fillimit < data_limit && k.data_fillimit > data
          if k.finished && k.lloji_pushimit == "Pushim Mjekesor"
            minus_kaluar = k.numri_diteve_spec(data_limit)
          else
            next
          end
        else
          next
        end
      elsif k.data_mbarimit <= data_limit
        if k.data_fillimit > data_fillimit
          if k.finished && k.lloji_pushimit == "Pushim Mjekesor"
            minus_kaluar = k.numri_diteve
          else
            next
          end
        end
      else
        next
      end
    end
    return pushimi - minus_kaluar
  end
end
