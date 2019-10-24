class Order < ApplicationRecord
  has_many :order_items

  def determine_status 
    if self.name.nil? 
      self.status = "pending"
    elsif #if all fields are complete and order was made less than 24 hours ago you can still edit
      #self.created_at > Datetime.now - 1.day 
      self.status = "paid"
    elsif #if all fields are complete and order was made more than 24 hours ago, no editing possible
      self.status = "complete"
    end 
  end 

  def total_cost
    total_cost = 0
    self.order_items.each do |item|
      total_cost += (item.product.price * item.quantity)
    end 
    return total_cost
  end 
end 

