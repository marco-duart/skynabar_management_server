class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :sku
      t.integer :unit_type
      t.decimal :current_quantity
      t.decimal :ideal_quantity
      t.belongs_to :product_category, null: false, foreign_key: true

      t.timestamps
    end
    add_index :products, :sku, unique: true
  end
end
