module Api
  module V1
    class BuyersController < ApplicationController
      # GET /api/v1/buyers
      def index
        buyers = Buyer.all

        render json: buyers, status: :ok
      end

      # GET /api/v1/buyers/:id
      def show
        buyer = Buyer.find(params[:id])

        render json: buyer, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Buyer not found" }, status: :not_found
      end
    end
  end
end
