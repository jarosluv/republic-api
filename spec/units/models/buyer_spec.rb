RSpec.describe Buyer do
  fixtures :buyers, :buy_orders, :business_entities, :business_owners

  subject(:buyer) { buyers(:new_buyer) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(buyer).to be_valid
    end

    context "name validations" do
      it "requires a name with a minimum of 2 characters" do
        buyer.name = "A"
        expect(buyer).not_to be_valid
        expect(buyer.errors[:name]).to include("is too short (minimum is 2 characters)")
      end

      it "enforces uniqueness of name" do
        duplicate_buyer = buyer.dup

        expect(duplicate_buyer).not_to be_valid
        expect(duplicate_buyer.errors[:name]).to include("has already been taken")
      end
    end

    context "available_funds validations" do
      it "is valid when available_funds is 0" do
        buyer.available_funds = 0
        expect(buyer).to be_valid
      end

      it "is invalid when available_funds is negative" do
        buyer.available_funds = -0.01
        expect(buyer).not_to be_valid
        expect(buyer.errors[:available_funds]).to include("must be greater than or equal to 0")
      end
    end
  end

  describe "dependent: restrict_with_exception" do
    subject(:buyer) { buyers(:buyer_with_shares) }

    it "raises an error when trying to destroy a buyer with associated buy_orders" do
      expect { buyer.destroy }.to raise_error(ActiveRecord::DeleteRestrictionError)
    end
  end
end
