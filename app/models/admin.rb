class Admin < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
  validates :sending_mail, presence: true
  validates :password, length: { minimum: 6 , allow_blank: true }
  validates :password_confirmation, length: { minimum: 6 , allow_blank: true }
  validates :lang, presence: true
  has_many :logs

end
