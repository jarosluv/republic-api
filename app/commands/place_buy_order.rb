class PlaceBuyOrder
  include Dry::Monads[:result, :do]

  # Attempts to place a buy order for a given entity and buyer.
  #
  # @param entity [ActiveRecord::Base] the record representing the entity offering shares.
  # @param buyer [ActiveRecord::Base] the buyer placing the order.
  # @param quantity [Integer] the number of shares to purchase.
  # @return [Dry::Monads::Result] Success(BuyOrder) if the order was placed,
  #   or a Failure symbol describing the error.
  def call(entity, buyer, quantity)
    ActiveRecord::Base.transaction do
      entity.with_lock do
        buyer.with_lock do
          yield check_funds(buyer, entity, quantity)
          yield check_share_quantity(entity, quantity)
          yield update_records(entity, buyer, quantity)

          create_order(entity, buyer, quantity)
        end
      end
    end
  end

  private

  # Checks that the buyer has enough funds to cover the purchase.
  #
  # @return [Dry::Monads::Result] Success(buyer) if funds are sufficient; otherwise, Failure(:insufficient_funds)
  def check_funds(buyer, entity, quantity)
    total_price = entity.share_price * quantity
    if buyer.available_funds >= total_price
      Success(buyer)
    else
      Failure(:insufficient_funds)
    end
  end

  # Checks that the entity has enough shares available.
  #
  # @return [Dry::Monads::Result] Success(entity) if sufficient shares are available; otherwise, Failure(:insufficient_shares)
  def check_share_quantity(entity, quantity)
    if entity.available_shares >= quantity
      Success(entity)
    else
      Failure(:insufficient_shares)
    end
  end

  # Updates the entity and buyer records with the new share and funds values.
  #
  # @return [Dry::Monads::Result] Success([entity, buyer]) if updates succeed; otherwise, Failure(:update_failed)
  def update_records(entity, buyer, quantity)
    entity.available_shares -= quantity
    buyer.available_funds -= entity.share_price * quantity

    entity.save!
    buyer.save!

    Success([ entity, buyer ])
  rescue StandardError => error
    Rails.logger.error("Update records error: #{error.message}")
    Failure(:update_failed)
  end

  # Creates a new buy order record.
  #
  # @return [Dry::Monads::Result] Success(order) if the order is created; otherwise, Failure(:order_creation_failed)
  def create_order(entity, buyer, quantity)
    order = entity.buy_orders.create!(
      buyer: buyer,
      share_quantity: quantity,
      share_price: entity.share_price
    )
    Success(order)
  rescue ActiveRecord::RecordInvalid => error
    Rails.logger.error("Create order error: #{error.message}")
    Failure(:order_creation_failed)
  end
end
