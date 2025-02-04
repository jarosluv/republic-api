RSpec.describe BuyOrder do
  fixtures :buy_orders, :buyers, :business_entities, :business_owners

  describe 'status enum' do
    subject(:buy_order) { buy_orders(:pending_order) }

    it 'has a default status of pending if set that way' do
      expect(buy_order.status).to eq('pending')
      expect(buy_order).to be_pending
    end

    it 'can transition to accepted' do
      buy_order.accepted!
      expect(buy_order.status).to eq('accepted')
      expect(buy_order).to be_accepted
    end

    it 'can transition to rejected' do
      buy_order.rejected!
      expect(buy_order.status).to eq('rejected')
      expect(buy_order).to be_rejected
    end
  end
end
