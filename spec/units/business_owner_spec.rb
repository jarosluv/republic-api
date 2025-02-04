RSpec.describe BusinessOwner do
  fixtures :business_owners, :business_entities

  subject(:business_owner) { business_owners(:owner) }

  describe "validations" do
    it "is valid with a name of at least 2 characters" do
      expect(business_owner).to be_valid
    end

    it "is invalid with a name shorter than 2 characters" do
      business_owner.name = "A"
      expect(business_owner).not_to be_valid
      expect(business_owner.errors[:name]).to include("is too short (minimum is 2 characters)")
    end
  end

  describe "dependent: :restrict_with_exception" do
    context "when the business owner has existing business_entities" do
      it "raises an error upon destruction" do
        expect { business_owner.destroy }.to raise_error(ActiveRecord::DeleteRestrictionError)
      end
    end
  end
end
