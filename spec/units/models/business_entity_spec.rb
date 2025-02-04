RSpec.describe BusinessEntity do
  fixtures :business_owners, :business_entities, :buy_orders

  subject(:business_entity) { business_entities(:company) }

  describe "validations" do
    it "is valid with correct attributes" do
      expect(business_entity).to be_valid
    end

    it "is invalid with a name shorter than 2 characters" do
      business_entity.name = "A"
      expect(business_entity).not_to be_valid
      expect(business_entity.errors[:name]).to include("is too short (minimum is 2 characters)")
    end

    it "enforces uniqueness of name scoped to business_owner" do
      duplicate_business_entity = business_entity.dup

      expect(duplicate_business_entity).not_to be_valid
      expect(duplicate_business_entity.errors[:name]).to include("has already been taken")
    end

    it "allows duplication for another business_owner" do
      duplicate_business_entity = business_entity.dup
      duplicate_business_entity.business_owner = business_owners(:owner_without_business)

      expect(duplicate_business_entity).to be_valid
    end

    it "is invalid when available_shares is negative" do
      business_entity.available_shares = -1
      expect(business_entity).not_to be_valid
      expect(business_entity.errors[:available_shares]).to include("must be greater than or equal to 0")
    end

    it "is invalid when share_price is zero or negative" do
      business_entity.share_price = 0
      expect(business_entity).not_to be_valid
      expect(business_entity.errors[:share_price]).to include("must be greater than 0")

      business_entity.share_price = -10
      expect(business_entity).not_to be_valid
      expect(business_entity.errors[:share_price]).to include("must be greater than 0")
    end
  end

  describe "dependent: :restrict_with_exception" do
    context "when the business_entity has associated buy_orders" do
      it "raises an error on destroy" do
        expect { business_entity.destroy }.to raise_error(ActiveRecord::DeleteRestrictionError)
      end
    end

    context "when the business_entity has no associated buy_orders" do
      it "allows destruction" do
        business_entity_without_orders = business_entities(:company_without_orders)
        expect { business_entity_without_orders.destroy }.not_to raise_error
        expect(business_entity_without_orders).to be_destroyed
      end
    end
  end
end
