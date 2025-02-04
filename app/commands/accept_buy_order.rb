class AcceptBuyOrder
  include Dry::Monads[:result, :do]

  def call(buy_order)
    buy_order.with_lock do
      buy_order.accept!
    end
    Success(buy_order)
  rescue RuntimeError => e
    Rails.logger.error("AcceptBuyOrder error: #{e.message}")
    Failure(:buy_order_not_saved)
  end
end
