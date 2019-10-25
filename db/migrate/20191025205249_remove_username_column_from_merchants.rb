class RemoveUsernameColumnFromMerchants < ActiveRecord::Migration[5.2]
  def change
    remove_column :merchants, :username
  end
end
