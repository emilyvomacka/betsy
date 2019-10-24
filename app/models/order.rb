class Order < ApplicationRecord
  has_many :order_items
  
  def total_cost
    total_cost = 0
    self.order_items.each do |item|
      total_cost += (item.product.price * item.quantity)
    end 
    return total_cost
  end 

end 

