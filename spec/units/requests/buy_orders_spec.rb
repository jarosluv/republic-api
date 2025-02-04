require 'dry/monads/result'

RSpec.describe "BuyOrders API", type: :request do
  fixtures :buy_orders, :business_entities, :buyers

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

  describe "POST /buy_orders" do
    let!(:entity) { business_entities(:company) }
    let!(:buyer)  { buyers(:buyer_with_shares) }
    let(:quantity) { 10 }
    let(:params)   { { buyer_id: buyer.id, quantity: quantity } }

    let(:place_buy_order_double) { instance_double(PlaceBuyOrder) }

    before do
      allow(PlaceBuyOrder).to receive(:new).and_return(place_buy_order_double)
    end

    context "when the order is placed successfully" do
      before do
        success_result = Dry::Monads::Success(buy_orders(:pending_order))
        allow(place_buy_order_double).to receive(:call).and_return(success_result)
      end

      it "returns a success response with status 201" do
        post "/api/v1/business_entities/#{entity.id}/buy_orders", params: params, as: :json
        expect(response).to have_http_status(:created)
        expect(response).to conform_schema(201)

        json = JSON.parse(response.body)
        expect(json["status"]).to eq("pending")
      end
    end

    context "when the buyer has insufficient funds" do
      before do
        failure_result = Dry::Monads::Failure(:insufficient_funds)
        allow(place_buy_order_double).to receive(:call).and_return(failure_result)
      end

      it "returns an error response with status 422" do
        post "/api/v1/business_entities/#{entity.id}/buy_orders", params: params, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to conform_schema(422)

        json = JSON.parse(response.body)
        expect(json["status"]).to eq("error")
        expect(json["message"]).to eq("Insufficient funds available to complete the purchase.")
      end
    end

    context "when the entity has insufficient shares" do
      before do
        failure_result = Dry::Monads::Failure(:insufficient_shares)
        allow(place_buy_order_double).to receive(:call).and_return(failure_result)
      end

      it "returns an error response with status 422" do
        post "/api/v1/business_entities/#{entity.id}/buy_orders", params: params, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to conform_schema(422)

        json = JSON.parse(response.body)
        expect(json["status"]).to eq("error")
        expect(json["message"]).to eq("Not enough shares available.")
      end
    end

    context "when an unexpected error occurs" do
      before do
        failure_result = Dry::Monads::Failure(:update_failed)
        allow(place_buy_order_double).to receive(:call).and_return(failure_result)
      end

      it "returns an error response with status 422" do
        post "/api/v1/business_entities/#{entity.id}/buy_orders", params: params, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to conform_schema(422)

        json = JSON.parse(response.body)
        expect(json["status"]).to eq("error")
        expect(json["message"]).to eq("An error occurred while processing your order. Please try again later.")
      end
    end

    context "when the entity is not found" do
      it "returns a not found response with status 404" do
        # Here, we do not stub the command because the error will occur during the lookup.
        post "/api/v1/business_entities/#{entity.id}/buy_orders", params: { buyer_id: -1, quantity: quantity }, as: :json
        expect(response).to have_http_status(:not_found)
        expect(response).to conform_schema(404)

        json = JSON.parse(response.body)
        expect(json["status"]).to eq("error")
        expect(json["message"]).to match(/Business entity or buyer not found/)
      end
    end
  end

  describe "PUT /api/v1/buy_orders/:buy_order_id/accept" do
    let(:buy_order) { buy_orders(:pending_order) }
    let(:accept_buy_order_double) { instance_double(AcceptBuyOrder) }

    before do
      allow(AcceptBuyOrder).to receive(:new).and_return(accept_buy_order_double)
    end

    context "when the buy_order is accepted successfully" do
      before do
        success_result = Dry::Monads::Success(buy_order)
        allow(accept_buy_order_double).to receive(:call).and_return(success_result)
      end

      it "returns a 200 OK response and the buy_order JSON" do
        put "/api/v1/buy_orders/#{buy_order.id}/accept"
        expect(response).to have_http_status(:ok)
        expect(response).to conform_schema(200)

        json = JSON.parse(response.body)
        expect(json["id"]).to eq(buy_order.id)
      end
    end

    context "when accepting the buy_order fails" do
      before do
        allow(accept_buy_order_double).to receive(:call).and_return(Dry::Monads::Failure(:buy_order_not_saved))
      end

      it "returns a 422 Unprocessable Entity with an error message" do
        put "/api/v1/buy_orders/#{buy_order.id}/accept"
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to conform_schema(422)

        json = JSON.parse(response.body)
        expect(json["status"]).to eq("error")
        expect(json["message"]).to match /An error occurred while processing your order. Please try again later./
      end
    end

    context "when the buy_order is not found" do
      it "returns a 404 Not Found" do
        put "/api/v1/buy_orders/999999/accept"  # Nonexistent ID
        expect(response).to have_http_status(:not_found)
        expect(response).to conform_schema(404)

        json = JSON.parse(response.body)
        expect(json["status"]).to eq("error")
        expect(json["message"]).to eq("Buy order not found")
      end
    end
  end
end
