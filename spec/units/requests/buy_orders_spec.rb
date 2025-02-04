RSpec.describe "BuyOrders API", type: :request do
  fixtures :buy_orders, :business_entities

  describe "GET /api/v1/business_entities/:business_entity_id/buy_orders" do
    let(:business_entity) { business_entities(:company) }

    it "returns all business owners with status 200" do
      get "/api/v1/business_entities/#{business_entity.id}/buy_orders"
      expect(response).to have_http_status(:ok)
      expect(response).to conform_schema(200)

      json = JSON.parse(response.body)
      expect(json).to be_an Array
      expect(json.size).to eq business_entity.buy_orders.count
    end

    context "when the business owner does not exist" do
      it "returns a 404 not found error" do
        get "/api/v1/business_entities/999999/buy_orders"
        expect(response).to have_http_status(:not_found)
        expect(response).to conform_schema(404)

        json = JSON.parse(response.body)
        expect(json["error"]).to eq("Business entity not found")
      end
    end
  end
end
