class StockMovement < ApplicationRecord
  enum :movement_type, {
    input: 0,
    output: 1,
    adjustment: 2,
    reversal: 3
  }

  belongs_to :product
  belongs_to :user

  validates :quantity, numericality: { greater_than: 0 }
  validates :movement_type, presence: true

  after_create :update_product_stock

  private

  def update_product_stock
    case movement_type.to_sym
    when :input, :reversal
      product.increment!(:current_quantity, quantity)
    when :output
      product.decrement!(:current_quantity, quantity)
    when :adjustment
      product.update!(current_quantity: quantity)
    end
  end
end
