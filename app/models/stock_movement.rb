class StockMovement < ApplicationRecord
  enum :movement_type, {
    input: 0,
    output: 1,
    adjustment: 2,
    reversal: 3
  }

  belongs_to :product
  belongs_to :user

  validate :quantity_must_be_positive

  private

  def quantity_must_be_positive
    errors.add(:quantity, "deve ser maior que zero") if quantity <= 0
  end
end
