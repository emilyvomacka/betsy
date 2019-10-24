class Order < ApplicationRecord
  has_many :order_items
  
  
  # validates_presence_of :email_address, :mailing_address, :customer_name, :cc_number, :cc_expiration, :cc_security_code, :zip_code, :cart_status
  # validates :cc_number, length: { is: 16 }  
  # validates :cc_security_code, length: { is: 3 }  
  # validates :zip_code, length: { is: 5 }  
  
  
  validates :cart_status, presence: true
  
  
  
  
  
  def total_cost
    total_cost = 0
    self.order_items.each do |item|
      total_cost += (item.product.price * item.quantity)
    end 
    return total_cost
  end 
  
  private 
  
  def order_status_pending
    if cart_status :pending
      attributes = [email_address, mailing_address, customer_name, cc_number,  cc_expiration,  cc_security_code, zip_code] 
      attributes.each do |attribute|
        if attribute.presence == nil?
          errors.add(:email_address, :mailing_address, :customer_name, :cc_number, :cc_expiration, :cc_security_code, :zip_code, "Field cannot be empty!")
        end
      end
      if cc_number.length < 16 && cc_number.length > 16
        errors.add(:cc_number, "Credit card number must be 16 numbers")
      end
    end
    
  end 
end

