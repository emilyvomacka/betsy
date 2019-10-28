class Review < ApplicationRecord
  belongs_to :product 
  
  validates :text, presence: true
  validates :rating, presence: true, :inclusion => 1..5
end


