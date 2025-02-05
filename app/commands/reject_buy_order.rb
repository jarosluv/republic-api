class RejectBuyOrder
  include Dry::Monads[:result, :do]

  # Rejects a previously placed BuyOrder, reverting any changes made when it was placed.
  #
  # @param order [BuyOrder] the buy order record that needs to be rejected.
  # @return [Dry::Monads::Result] Success(order) if rollback is successful,
  #   or a Failure(:rollback_failed|:update_failed|:invalid_state) if the order can't be rejected.
  def call(order)
    ActiveRecord::Base.transaction do
      entity = order.business_entity
      buyer  = order.buyer

      entity.with_lock do
        buyer.with_lock do
          yield rollback_records(entity, buyer, order)
          yield update_order_status(order)

          Success(order)
        end
      end
    end
  end

  private

  # Revert any changes made to the buyer's funds and entity's available shares.
  #
  # @return [Dry::Monads::Result] Success([entity, buyer]) or Failure(:rollback_failed)
  def rollback_records(entity, buyer, order)
    begin
      buyer.available_funds += order.share_price * order.share_quantity
      entity.available_shares += order.share_quantity

      buyer.save!
      entity.save!

      Success([ entity, buyer ])
    rescue StandardError => e
      Rails.logger.error("Rollback error: #{e.message}")
      Failure(:rollback_failed)
    end
  end

  # Update the order's status to 'rejected'.
  #
  # @return [Dry::Monads::Result] Success(order) or Failure(:update_failed)
  def update_order_status(order)
    order.reject!

    Success(order)
  rescue RuntimeError, ActiveRecord::RecordInvalid => e
    Rails.logger.error("Order update error: #{e.message}")
    Failure(:update_failed)
  end
end
