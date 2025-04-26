class ProductCategory < ApplicationRecord
  has_many :products, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true, length: { minimum: 2 }
  validates :description, length: { maximum: 500 }
end
