class AddNicknameToMerchants < ActiveRecord::Migration[5.2]
  def change
    add_column :merchants, :nickname, :string
  end
end
