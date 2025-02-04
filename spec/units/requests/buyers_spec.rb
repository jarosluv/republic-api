RSpec.describe "Buyers API", type: :request do
  fixtures :buyers

  describe "GET /api/v1/buyers" do
    it "returns all buyers with status 200" do
      get "/api/v1/buyers"
      expect(response).to have_http_status(:ok)
      expect(response).to conform_schema(200)

      json = JSON.parse(response.body)
      expect(json).to be_an Array
      expect(json.size).to eq Buyer.count
    end
  end

  describe "GET /api/v1/buyers/:id" do
    context "when the buyer exists" do
      it "returns the buyer with status 200" do
        buyer = buyers(:buyer_with_shares)
        get "/api/v1/buyers/#{buyer.id}"
        expect(response).to have_http_status(:ok)
        expect(response).to conform_schema(200)

        json = JSON.parse(response.body)
        expect(json["id"]).to eq buyer.id
        expect(json["name"]).to eq "Bernardo"
        expect(json["available_funds"]).to eq "999.99"
      end
    end

    context "when the buyer does not exist" do
      it "returns a 404 not found error" do
        get "/api/v1/buyers/999999"
        expect(response).to have_http_status(:not_found)
        expect(response).to conform_schema(404)

        json = JSON.parse(response.body)
        expect(json["error"]).to eq "Buyer not found"
      end
    end
  end
end
