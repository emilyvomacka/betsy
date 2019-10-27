class Merchant < ApplicationRecord
  has_many :products, dependent: :destroy
  has_many :order_items, through: :products
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  
  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"
    merchant.name = auth_hash["info"]["nickname"]
    merchant.email = auth_hash["info"]["email"]
    return merchant
  end
  
  def total_revenue
    total_revenue = 0.0
    
    self.order_items.each do |order_item|
      total_revenue += order_item.total
    end
    
    return total_revenue
  end
  
  def revenue_by_status(status)
    total_revenue = 0.0
    
    self.order_items.each do |order_item|
      if order_item.order.cart_status == status
        total_revenue += order_item.total
      end
    end
    
    return total_revenue
  end
  
  def num_orders(status)
    total_orders = 0
    
    self.order_items.each do |order_item|
      if order_item.order.cart_status == status
        total_orders += 1
      end
      
    end
    
    return total_orders
    
  end
end

