class Product < ApplicationRecord
  has_many :reviews, dependent: :destroy
  belongs_to :merchant 
  has_many :order_items, dependent: :destroy
  has_and_belongs_to_many :categories
  
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :price, presence: true, numericality: {greater_than: 0}
  validates :photo_URL, presence: true
  validates :stock, presence: true
  validates :merchant_id, presence: true
  
  def retire
    if self.active
      return self.update(active: false)
    else
      return self.update(active: true)
    end
  end
  
end

