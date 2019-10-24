class Order < ApplicationRecord
  has_many :order_items
  
  #I think this method should only be used when we want to determine whether an order is paid or complete. Paid orders will still be able to be edited or cancelled, but complete orders will not display those options. "Pending" will be set by Order.create, and "Cancelled" will be set by the user.
  def determine_status 
    if Datetime.now.to_date - self.created_at.to_date < 1
      self.status = "paid"
    else #if all fields are complete and order was made more than 24 hours ago
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

