RSpec.describe "BusinessOwners API", type: :request do
  fixtures :business_owners

  describe "GET /api/v1/business_owners" do
    it "returns all business owners with status 200" do
      get "/api/v1/business_owners"
      expect(response).to have_http_status(:ok)
      expect(response).to conform_schema(200)

      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json.size).to eq(BusinessOwner.count)
    end
  end

  describe "GET /api/v1/business_owners/:id" do
    context "when the business owner exists" do
      it "returns the business owner with status 200" do
        owner = business_owners(:owner)
        get "/api/v1/business_owners/#{owner.id}"
        expect(response).to have_http_status(:ok)
        expect(response).to conform_schema(200)

        json = JSON.parse(response.body)
        expect(json["id"]).to eq(owner.id)
        expect(json["name"]).to eq(owner.name)
      end
    end

    context "when the business owner does not exist" do
      it "returns a 404 not found error" do
        get "/api/v1/business_owners/999999"
        expect(response).to have_http_status(:not_found)
        expect(response).to conform_schema(404)

        json = JSON.parse(response.body)
        expect(json["error"]).to eq("Business owner not found")
      end
    end
  end
end
