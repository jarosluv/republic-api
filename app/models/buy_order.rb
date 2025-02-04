class BuyOrder < ApplicationRecord
  belongs_to :business_entity, inverse_of: :buy_orders
  belongs_to :buyer, inverse_of: :buy_orders

  enum :status, { pending: "pending", accepted: "accepted", rejected: "rejected" } do
    event :accept do
      before { self.processed_at = Time.current }
      transition pending: :accepted
    end

    event :reject do
      before { self.processed_at = Time.current }
      transition pending: :rejected
    end
  end

  validates :share_quantity, numericality: { only_integers: true, greater_than: 0 }
  validates :share_price, numericality: { greater_than: 0 }
end
