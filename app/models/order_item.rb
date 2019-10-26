class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order
  
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def self.arrange_by_created_at
    return OrderItem.order(created_at: :asc)
  end

end