class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.decimal :price
      t.string :photo_URL
      t.integer :stock

      t.timestamps
    end
  end
end
