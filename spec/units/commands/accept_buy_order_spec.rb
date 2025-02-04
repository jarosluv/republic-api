RSpec.describe AcceptBuyOrder do
  fixtures :buy_orders

  let(:command) { described_class.new }

  describe "#call" do
    context "when accepting the buy order succeeds" do
      let(:buy_order) { buy_orders(:pending_order) }

      it "returns a Success with the buy_order" do
        result = command.call(buy_order)

        expect(result).to be_a(Dry::Monads::Result::Success)
        expect(result.success).to eq(buy_order)
      end
    end

    context "when an error occurs during acceptance" do
      let(:buy_order) { buy_orders(:accepted_order) }

      it "logs the error and returns a Failure with :buy_order_not_saved" do
        result = command.call(buy_order)

        expect(result).to be_a(Dry::Monads::Result::Failure)
        expect(result.failure).to eq(:buy_order_not_saved)
      end
    end
  end
end
