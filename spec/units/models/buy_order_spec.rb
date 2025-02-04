RSpec.describe BuyOrder do
  fixtures :buy_orders, :buyers, :business_entities, :business_owners

  describe 'status enum' do
    let(:buy_order) { buy_orders(:pending_order) }

    context 'when pending' do
      it 'can transition to accepted' do
        expect(buy_order.status).to eq('pending')

        buy_order.accept

        expect(buy_order.status).to eq('accepted')
      end

      it 'can transition to rejected' do
        expect(buy_order.status).to eq('pending')

        buy_order.reject

        expect(buy_order.status).to eq('rejected')
      end

      it 'sets processed_at upon accept' do
        expect(buy_order.processed_at).to be_nil

        buy_order.accept

        expect(buy_order.processed_at).not_to be_nil
      end

      it 'sets processed_at upon reject' do
        expect(buy_order.processed_at).to be_nil

        buy_order.reject

        expect(buy_order.processed_at).not_to be_nil
      end
    end

    context 'when accepted' do
      let(:buy_order) { buy_orders(:accepted_order) }

      it 'does not change status if #accept is called again' do
        expect { buy_order.accept }.not_to change(buy_order, :status)
      end

      it 'does not change processed_at if #accept is called again' do
        original_processed_at = buy_order.processed_at
        buy_order.accept
        expect(buy_order.processed_at).to eq(original_processed_at)
      end
    end

    context 'when rejected' do
      let(:buy_order) { buy_orders(:rejected_order) }

      it 'does not change status if #reject is called again' do
        expect { buy_order.reject }.not_to change(buy_order, :status)
      end

      it 'does not change processed_at if #reject is called again' do
        original_processed_at = buy_order.processed_at
        buy_order.reject
        expect(buy_order.processed_at).to eq(original_processed_at)
      end
    end
  end
end
