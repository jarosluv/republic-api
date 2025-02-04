RSpec.describe PlaceBuyOrder do
  fixtures :buyers, :business_entities

  let(:command) { described_class.new }
  let(:buyer) { buyers(:buyer_with_shares) }   # Assumes a fixture buyer named :one exists
  let(:entity) { business_entities(:company) }  # Assumes a fixture entity named :one exists
  let(:quantity) { 10 }

  before do
    # Ensure a known starting state for the buyer and entity.
    # Adjust these values according to your fixture structure.
    buyer.update!(available_funds: 1_000)
    entity.update!(available_shares: 100, share_price: 10)
  end

  describe "#call" do
    context "basic scenarios" do
      it "places an order and updates records when successful" do
        result = command.call(entity, buyer, quantity)
        expect(result).to be_success

        expected_funds = 1_000 - (entity.share_price * quantity)
        expect(buyer.reload.available_funds).to eq(expected_funds)
        expect(entity.reload.available_shares).to eq(100 - quantity)

        order = entity.buy_orders.last
        expect(order).to be_present
        expect(order.buyer_id).to eq(buyer.id)
        expect(order.share_quantity).to eq(quantity)
        expect(order.share_price).to eq(entity.share_price)
      end

      it "returns a Failure with :insufficient_funds when buyer funds are too low" do
        buyer.update!(available_funds: entity.share_price * (quantity - 1))
        result = command.call(entity, buyer, quantity)
        expect(result).to be_failure
        expect(result.failure).to eq(:insufficient_funds)
      end

      it "returns a Failure with :insufficient_shares when not enough shares are available" do
        entity.update!(available_shares: quantity - 1)
        result = command.call(entity, buyer, quantity)
        expect(result).to be_failure
        expect(result.failure).to eq(:insufficient_shares)
      end

      it "returns a Failure with :order_creation_failed when requested quantity is 0" do
        result = command.call(entity, buyer, 0)
        expect(result).to be_failure
        expect(result.failure).to eq(:order_creation_failed)
      end
    end

    context "border conditions" do
      it "succeeds when quantity is 0" do
        result = command.call(entity, buyer, 1)

        expect(result).to be_success

        expect(buyer.reload.available_funds).to eq(990)
        expect(entity.reload.available_shares).to eq(99)

        order = entity.buy_orders.last
        expect(order).to be_present
        expect(order.share_quantity).to eq(1)
      end

      it "succeeds when buyer funds exactly equal the required amount" do
        buyer.update!(available_funds: entity.share_price * quantity)
        result = command.call(entity, buyer, quantity)
        expect(result).to be_success

        expect(buyer.reload.available_funds).to eq(0)
        expect(entity.reload.available_shares).to eq(100 - quantity)
      end

      it "succeeds when the entity has exactly the order quantity of shares" do
        entity.update!(available_shares: quantity)
        result = command.call(entity, buyer, quantity)
        expect(result).to be_success

        expect(entity.reload.available_shares).to eq(0)
      end

      it "disallows a negative quantity" do
        result = command.call(entity, buyer, -5)
        expect(result).to be_failure
      end
    end

    context "concurrent requests" do
      it "handles concurrent orders without overselling shares" do
        # Reset records for concurrency test.
        buyer.update!(available_funds: 1_000)
        entity.update!(available_shares: 100, share_price: 10)

        # Two threads each attempting to purchase 60 shares concurrently.
        threads = []
        results = []
        20.times do
          threads << Thread.new do
            # Introduce a slight random delay to simulate race conditions.
            sleep(rand(0.01..0.05))
            results << PlaceBuyOrder.new.call(entity, buyer, 60)
          end
        end
        threads.each(&:join)

        successes = results.select(&:success?)
        failures  = results.select(&:failure?)

        # Because 20 x 60 = 1200 > 100 available shares, only one order should succeed.
        expect(successes.size).to eq(1)
        expect(failures.size).to eq(19)

        # Verify that the successful order deducted 60 shares.
        expect(entity.reload.available_shares).to eq(40)
        # And the buyer's funds decreased by 60 * share_price.
        expect(buyer.reload.available_funds).to eq(1_000 - (60 * 10))
      end
    end
  end
end
