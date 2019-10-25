class AddUidAndProviderToMerchants < ActiveRecord::Migration[5.2]
  def change
    add_column :merchants, :uid, :integer
    add_column :merchants, :provider, :string
    add_column :merchants, :email, :string
    add_column :merchants, :name, :string
  end
end
