RSpec.describe RejectBuyOrder do
  fixtures :buy_orders, :business_entities, :buyers

  subject(:command) { described_class.new }

  let!(:entity) { business_entities(:company) }
  let!(:buyer)  { buyers(:buyer_with_shares) }
  let!(:order)  { buy_orders(:pending_order) }

  describe "#call" do
    context "when the order is in a valid (pending) state" do
      it "returns a success monad" do
        result = command.call(order)

        expect(result).to be_a_success
        expect(result.success).to eq(order)
      end

      it "restores buyer funds" do
        expect do
          command.call(order)
        end.to change { buyer.reload.available_funds }
          .by(order.share_quantity * order.share_price)
      end

      it "restores entity shares" do
        expect do
          command.call(order)
        end.to change { entity.reload.available_shares }
          .by(order.share_quantity)
      end

      it "updates the order's status to 'rejected'" do
        command.call(order)
        expect(order.reload.status).to eq("rejected")
      end
    end

    context "when the order is not in a valid state" do
      before do
        order.update!(status: "accepted")
      end

      it "returns a failure with :invalid_state" do
        result = command.call(order)

        expect(result).to be_a_failure
        expect(result.failure).to eq(:update_failed)
      end

      it "does not restore buyer funds or entity shares" do
        funds_before = buyer.available_funds
        shares_before = entity.available_shares

        command.call(order)

        expect(buyer.reload.available_funds).to eq(funds_before)
        expect(entity.reload.available_shares).to eq(shares_before)
      end

      it "does not change the order status" do
        original_status = order.status
        command.call(order)
        expect(order.reload.status).to eq(original_status)
      end
    end

    context "when an error occurs while restoring shares/funds" do
      before do
        allow(buyer).to receive(:save!).and_raise(ActiveRecord::RecordInvalid.new(buyer))
        order.buyer = buyer
      end

      it "returns a failure with :rollback_failed" do
        result = command.call(order)

        expect(result).to be_a_failure
        expect(result.failure).to eq(:rollback_failed)
      end

      it "does not partially update buyer or entity" do
        buyer_before   = buyer.available_funds
        entity_before  = entity.available_shares

        command.call(order)

        expect(buyer.reload.available_funds).to eq(buyer_before)
        expect(entity.reload.available_shares).to eq(entity_before)
      end

      it "does not update the order status" do
        command.call(order)
        expect(order.reload.status).to eq("pending")
      end
    end

    context "when an error occurs while updating the order status" do
      before do
        allow(order).to receive(:update!).and_raise(ActiveRecord::RecordInvalid.new(order))
      end

      it "returns a failure with :update_failed" do
        result = command.call(order)

        expect(result).to be_a_failure
        expect(result.failure).to eq(:update_failed)
      end

      it "rolls back changes to buyer funds and entity shares" do
        buyer_before   = buyer.available_funds
        entity_before  = entity.available_shares

        command.call(order)

        expect(buyer.reload.available_funds).to eq(buyer_before)
        expect(entity.reload.available_shares).to eq(entity_before)
      end
    end
  end
end
