module Api
  module V1
    class BuyOrdersController < ApplicationController
      # GET /api/v1/business_entities/:business_entity_id/buy_orders
      def index
        business_entity = BusinessEntity.find(params[:business_entity_id])
        buy_orders = business_entity.buy_orders

        render json: buy_orders, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Business entity not found" }, status: :not_found
      end

      # POST /api/v1/business_entities/:business_entity_id/buy_orders
      def create
        entity = BusinessEntity.find(params[:business_entity_id])
        buyer = Buyer.find(params.require(:buyer_id))
        quantity = params.require(:quantity).to_i

        result = PlaceBuyOrder.new.call(entity, buyer, quantity)

        if result.success?
          render json: result.value!, status: :created
        else
          render json: { status: "error", message: error_message(result.failure) }, status: :unprocessable_content
        end
      rescue ActiveRecord::RecordNotFound
        render json: { status: "error", message: "Business entity or buyer not found" }, status: :not_found
      end

      # PUT /api/v1/buy_orders/:buy_order_id/accept
      def accept
        buy_order = BuyOrder.find(params[:buy_order_id])
        result = AcceptBuyOrder.new.call(buy_order)

        if result.success?
          render json: result.value!, status: :ok
        else
          render json: { status: "error", message: error_message(result.failure) }, status: :unprocessable_content
        end
      rescue ActiveRecord::RecordNotFound
        render json: { status: "error", message: "Buy order not found" }, status: :not_found
      end

      private

      def error_message(error)
        case error
        when :insufficient_funds
          "Insufficient funds available to complete the purchase."
        when :insufficient_shares
          "Not enough shares available."
        when :update_failed, :order_creation_failed, :buy_order_not_saved
          "An error occurred while processing your order. Please try again later."
        else
          "An unknown error occurred."
        end
      end
    end
  end
end
