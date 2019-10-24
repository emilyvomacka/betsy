class AddProductStatusAndOrderStatus < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :product_status, :string
    add_column :orders, :cart_status, :string
  end
end
