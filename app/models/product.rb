class Product < ApplicationRecord
  enum :unit_type, {
    unit: 0,
    liter: 1,
    kilogram: 2,
    bottle: 3,
    pack: 4,
    box: 5
  }

  belongs_to :product_category
  has_many :stock_movements

  validates :name, :unit_type, :ideal_quantity, presence: true
  validates :sku, uniqueness: true
  validates :current_quantity, :ideal_quantity, numericality: { greater_than_or_equal_to: 0 }

  def needs_restock?
    current_quantity < ideal_quantity
  end

  def quantity_to_buy
    [ ideal_quantity - current_quantity, 0 ].max.round(2)
  end

  def restock_percentage
    return 0 if ideal_quantity.zero?
    [ (current_quantity / ideal_quantity * 100).round(2), 100 ].min
  end
end
