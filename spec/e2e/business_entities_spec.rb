RSpec.describe "BusinessEntities API", type: :request do
  fixtures :business_entities

  let(:business_entity) { business_entities(:company) }

  describe "GET /api/v1/business_owners/:id/business_entities" do
    it "returns all business owners with status 200" do
      get "/api/v1/business_owners/#{business_entity.business_owner_id}/business_entities"
      expect(response).to have_http_status(:ok)
      expect(response).to conform_schema(200)

      json = JSON.parse(response.body)
      expect(json).to be_an Array
      expect(json.size).to eq business_entity.business_owner.business_entities.count
    end

    context "when the business owner does not exist" do
      it "returns a 404 not found error" do
        get "/api/v1/business_owners/999999/business_entities"
        expect(response).to have_http_status(:not_found)
        expect(response).to conform_schema(404)

        json = JSON.parse(response.body)
        expect(json["error"]).to eq("Business owner not found")
      end
    end
  end

  describe "GET /api/v1/business_entities/available" do
    it "returns all available business entities with status 200" do
      get "/api/v1/business_entities/available"
      expect(response).to have_http_status(:ok)
      expect(response).to conform_schema(200)

      json = JSON.parse(response.body)
      expect(json).to be_an Array
      expect(json.size).to eq BusinessEntity.available_for_trading.count
    end
  end

  describe "GET /api/v1/business_entities/:id" do
    context "when the business entity exists" do
      it "returns the business entity with status 200" do
        get "/api/v1/business_entities/#{business_entity.id}"
        expect(response).to have_http_status(:ok)
        expect(response).to conform_schema(200)

        json = JSON.parse(response.body)
        expect(json["id"]).to eq business_entity.id
        expect(json["name"]).to eq "Company"
        expect(json["available_shares"]).to eq 150
        expect(json["share_price"]).to eq "5.0"
      end
    end

    context "when the business entity does not exist" do
      it "returns a 404 not found error" do
        get "/api/v1/business_entities/999999"
        expect(response).to have_http_status(:not_found)
        expect(response).to conform_schema(404)

        json = JSON.parse(response.body)
        expect(json["error"]).to eq "Business entity not found"
      end
    end
  end
end
