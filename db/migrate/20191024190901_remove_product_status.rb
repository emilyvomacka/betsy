class RemoveProductStatus < ActiveRecord::Migration[5.2]
  def change
    remove_column :products, :product_status
  end
end
