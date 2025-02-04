module Api
  module V1
    class BusinessOwnersController < ApplicationController
      # GET /api/v1/business_owners
      def index
        business_owners = BusinessOwner.all
        render json: business_owners, status: :ok
      end

      # GET /api/v1/business_owners/:id
      def show
        business_owner = BusinessOwner.find(params[:id])
        render json: business_owner, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Business owner not found" }, status: :not_found
      end
    end
  end
end
