class Merchant < ApplicationRecord
  has_many :products 
  
  validates :username, presence: true, uniqueness: true
  
end
