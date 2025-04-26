class CreateStockMovements < ActiveRecord::Migration[8.0]
  def change
    create_table :stock_movements do |t|
      t.belongs_to :product, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.decimal :quantity
      t.integer :movement_type

      t.timestamps
    end
  end
end
