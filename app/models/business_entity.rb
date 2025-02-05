class BusinessEntity < ApplicationRecord
  belongs_to :business_owner, inverse_of: :business_entities
  has_many :buy_orders, inverse_of: :business_entity, dependent: :restrict_with_exception

  scope :available_for_trading, -> { where("available_shares > 0") }

  validates :name, length: { minimum: 2 }, uniqueness: { scope: :business_owner }
  validates :available_shares, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :share_price, numericality: { greater_than: 0 }
end
