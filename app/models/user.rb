class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  enum :role, {
    employee: 0,
    manager: 1
  }

  validates :document,
    presence: true,
    uniqueness: true,
    length: { is: 11 },
    numericality: { only_integer: true }

  validates :name, :role, presence: true
end
