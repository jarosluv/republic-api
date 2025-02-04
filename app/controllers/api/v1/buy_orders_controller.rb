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
    end
  end
end
