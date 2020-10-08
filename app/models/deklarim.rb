class Deklarim < ApplicationRecord
	has_many :pagas, dependent: :destroy
end
