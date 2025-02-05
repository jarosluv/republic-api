module Api
  module V1
    class BusinessEntitiesController < ApplicationController
      # GET /api/v1/business_owners/:business_owner_id/business_entities
      def index
        business_owner = BusinessOwner.find(params[:business_owner_id])
        business_entities = business_owner.business_entities

        render json: business_entities, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Business owner not found" }, status: :not_found
      end

      # GET /api/v1/business_entities/available
      def available
        business_entities = BusinessEntity.available_for_trading

        render json: business_entities, status: :ok
      end


      # GET /api/v1/business_entities/:id
      def show
        business_entity = BusinessEntity.find(params[:id])

        render json: business_entity, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Business entity not found" }, status: :not_found
      end
    end
  end
end
