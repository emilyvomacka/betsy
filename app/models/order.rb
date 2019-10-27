class Order < ApplicationRecord
  has_many :order_items
  
  validates_presence_of :email_address, :mailing_address, :customer_name, :cc_number, :cc_expiration, :cc_security_code, :zip_code, :cart_status, on: :update 
  validates :cc_number, length: { is: 16 }, on: :update
  validates :cc_security_code, length: { is: 3 }, on: :update 
  validates :zip_code, length: { is: 5 }, on: :update
  
  validates :cart_status, presence: true
  
  def total_cost
    total_cost = 0
    self.order_items.each do |item|
      total_cost += (item.product.price * item.quantity)
    end 
    return total_cost
  end 
  
  def consolidate_order_items(new_item_id, new_item_quantity)
    self.order_items.each do |item|
      if item.product.id.to_s == new_item_id 
        item.quantity += new_item_quantity.to_i
        item.save 
        return true 
      end
    end 
    return false
  end 
  
  def return_merchant_items(current_merchant_id)
    merchant_items = []
    self.order_items.each do |current_item|
      if current_item.product.merchant.id == current_merchant_id
        merchant_items << current_item
      end 
    end 
    return merchant_items
  end 
  
  def return_merchants
    merchants = []
    self.order_items.each do |current_item|
      merchants << Merchant.find_by(id: current_item.product.merchant_id)
    end 
    return merchants 
  end 

  def existing_quantity(new_product_id)
    self.order_items.each do |current_item|
      puts "I am in an existing item"
      if current_item.product.id == new_product_id.to_i
        return current_item.quantity.to_i
        puts "I have returned quantity #{current_item.quantity}"
      end 
    end 
    return 0
  end 

  private 
  
  # def order_status_pending
  #   if cart_status :pending
  #     attributes = [email_address, mailing_address, customer_name, cc_number,  cc_expiration,  cc_security_code, zip_code] 
  #     attributes.each do |attribute|
  #       if attribute.presence == nil?
  #         errors.add(:email_address, :mailing_address, :customer_name, :cc_number, :cc_expiration, :cc_security_code, :zip_code, "Field cannot be empty!")
  #       end
  #     end
  #     if cc_number.length < 16 && cc_number.length > 16
  #       errors.add(:cc_number, "Credit card number must be 16 numbers")
  #     end
  #   end
  
  # end 
end

