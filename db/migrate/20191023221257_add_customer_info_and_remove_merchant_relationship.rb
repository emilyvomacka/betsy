class AddCustomerInfoAndRemoveMerchantRelationship < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :email_address, :string
    add_column :orders, :mailing_address, :string
    add_column :orders, :customer_name, :string
    add_column :orders, :cc_number, :string
    add_column :orders, :cc_expiration, :string
    add_column :orders, :cc_security_code, :string
    add_column :orders, :zip_code, :string
    remove_column :orders, :merchant_id
  end
end
