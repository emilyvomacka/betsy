class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  
  validates_presence_of :email_address, :mailing_address, :customer_name, :cc_number, :cc_expiration, :cc_security_code, :zip_code, :cart_status, on: :update 
  validates :cc_number, length: { is: 16 }, on: :update
  validates :cc_security_code, length: { is: 3 }, on: :update 
  validates :zip_code, length: { is: 5 }, on: :update
  validates :cart_status, presence: true
  
  def total_cost
    total_cost = 0
    if self.order_items.any? 
      self.order_items.each do |item|
        total_cost += item.total
      end 
    end 
    return total_cost
  end 
  
  def consolidate_order_items(new_product_id, new_quantity)
    if self.order_items.any?
      self.order_items.each do |item|
        if item.product.id.to_s == new_product_id.to_s
          item.quantity += new_quantity.to_i
          item.save 
          return true 
        end
      end 
    end 
    return false
  end 

  def check_stock 
    self.order_items.each do |item|
      if item.quantity > item.product.stock
        return [false, item.product.name, item.product.stock]  
      end 
    end 
    return [true]
  end 
  
  def return_merchant_items(current_merchant_id)
    merchant_items = []
    if self.order_items.any? 
      self.order_items.each do |current_item|
        if current_item.product.merchant.id == current_merchant_id
          merchant_items << current_item
        end 
      end 
    end 
    return merchant_items
  end 
  
  def return_merchants
    merchants = []
    self.order_items.each do |current_item|
      merchants << Merchant.find_by(id: current_item.product.merchant_id)
    end 
    return merchants.any? ? merchants.uniq : merchants
  end 
  
  def existing_quantity(new_product_id)
    if self.order_items.any?
      self.order_items.each do |current_item|
        if current_item.product.id == new_product_id
          return current_item.quantity.to_i
        end 
      end 
    end 
    return 0
  end
end
