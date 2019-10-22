class AddOrderItemsAndMerchantToOrder < ActiveRecord::Migration[5.2]
  def change
    add_reference :order_items, :order, foreign_key: true
    add_reference :orders, :merchant, foreign_key: true
  end
end
