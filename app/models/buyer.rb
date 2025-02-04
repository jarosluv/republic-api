class Buyer < ApplicationRecord
  has_many :buy_orders, inverse_of: :buyer, dependent: :restrict_with_exception

  validates :name, length: { minimum: 2 }, uniqueness: true
  validates :available_funds, numericality: { greater_than_or_equal_to: 0 }
end
