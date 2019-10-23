class Product < ApplicationRecord
  has_many :reviews
  belongs_to :merchant 
  has_many :order_items
  has_and_belongs_to_many :categories
  
  def retire
    if self.active
      return self.update(active: false)
    else
      return self.update(active: true)
    end
  end
  
end
