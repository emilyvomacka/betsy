class AddActiveToProducts < ActiveRecord::Migration[5.2]
  def change 
    change_table :products do |t|
      t.boolean :active  
    end
  end
end
