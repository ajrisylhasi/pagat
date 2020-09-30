class Paga < ApplicationRecord
  belongs_to :user
  belongs_to :deklarim
end
