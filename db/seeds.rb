# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data
puts "Cleaning database..."
BuyOrder.delete_all
BusinessEntity.delete_all
BusinessOwner.delete_all
Buyer.delete_all

# Create Business Owners
puts "Creating business owners..."
owners = {
  tech_mogul: BusinessOwner.create!(name: "Tech Mogul"),
  retail_giant: BusinessOwner.create!(name: "Retail Giant"),
  startup_founder: BusinessOwner.create!(name: "Startup Founder"),
  inactive_owner: BusinessOwner.create!(name: "Inactive Owner"),
  manufacturing_ceo: BusinessOwner.create!(name: "Manufacturing CEO"),
  real_estate_mogul: BusinessOwner.create!(name: "Real Estate Mogul"),
  franchise_owner: BusinessOwner.create!(name: "Franchise Owner"),
  venture_capitalist: BusinessOwner.create!(name: "Venture Capitalist")
}

# Create Business Entities
puts "Creating business entities..."
entities = {
  tech_corp: BusinessEntity.create!(
    business_owner: owners[:tech_mogul],
    name: "Tech Corp",
    available_shares: 10000,
    share_price: 500.00
  ),
  
  corner_store: BusinessEntity.create!(
    business_owner: owners[:retail_giant],
    name: "Corner Store Chain",
    available_shares: 100,
    share_price: 10.00
  ),
  
  sold_out_startup: BusinessEntity.create!(
    business_owner: owners[:startup_founder],
    name: "Sold Out Startup",
    available_shares: 0,
    share_price: 50.00
  ),
  
  luxury_brand: BusinessEntity.create!(
    business_owner: owners[:retail_giant],
    name: "Luxury Brand Co",
    available_shares: 50,
    share_price: 1000.00
  ),

  manufacturing_plant: BusinessEntity.create!(
    business_owner: owners[:manufacturing_ceo],
    name: "Industrial Manufacturing",
    available_shares: 5000,
    share_price: 75.50
  ),

  real_estate_trust: BusinessEntity.create!(
    business_owner: owners[:real_estate_mogul],
    name: "Property Trust",
    available_shares: 2500,
    share_price: 250.00
  ),

  restaurant_chain: BusinessEntity.create!(
    business_owner: owners[:franchise_owner],
    name: "Global Restaurants",
    available_shares: 300,
    share_price: 45.00
  ),

  tech_startup: BusinessEntity.create!(
    business_owner: owners[:venture_capitalist],
    name: "AI Solutions",
    available_shares: 1000,
    share_price: 150.00
  )
}

# Create Buyers
puts "Creating buyers..."
buyers = {
  wealthy_investor: Buyer.create!(
    name: "Wealthy Investor",
    available_funds: 1_000_000.00
  ),
  
  average_joe: Buyer.create!(
    name: "Average Joe",
    available_funds: 1000.00
  ),
  
  broke_buyer: Buyer.create!(
    name: "Broke Buyer",
    available_funds: 0.00
  ),
  
  careful_investor: Buyer.create!(
    name: "Careful Investor",
    available_funds: 5000.00
  ),

  institutional_investor: Buyer.create!(
    name: "Institutional Investor",
    available_funds: 5_000_000.00
  ),

  day_trader: Buyer.create!(
    name: "Day Trader",
    available_funds: 25000.00
  ),

  pension_fund: Buyer.create!(
    name: "Pension Fund",
    available_funds: 10_000_000.00
  ),

  small_investor: Buyer.create!(
    name: "Small Investor",
    available_funds: 2500.00
  )
}

# Create Buy Orders
puts "Creating buy orders..."
orders = {
  pending_small: BuyOrder.create!(
    business_entity: entities[:tech_corp],
    buyer: buyers[:wealthy_investor],
    status: "pending",
    share_quantity: 10,
    share_price: 500.00,
    placed_at: Time.current
  ),
  
  pending_large: BuyOrder.create!(
    business_entity: entities[:corner_store],
    buyer: buyers[:average_joe],
    status: "pending",
    share_quantity: 50,
    share_price: 10.00,
    placed_at: Time.current - 1.day
  ),
  
  accepted_recent: BuyOrder.create!(
    business_entity: entities[:tech_corp],
    buyer: buyers[:wealthy_investor],
    status: "accepted",
    share_quantity: 5,
    share_price: 500.00,
    placed_at: Time.current - 2.days,
    processed_at: Time.current - 1.day
  ),
  
  accepted_old: BuyOrder.create!(
    business_entity: entities[:luxury_brand],
    buyer: buyers[:careful_investor],
    status: "accepted",
    share_quantity: 2,
    share_price: 1000.00,
    placed_at: Time.current - 30.days,
    processed_at: Time.current - 29.days
  ),

  pending_medium: BuyOrder.create!(
    business_entity: entities[:manufacturing_plant],
    buyer: buyers[:institutional_investor],
    status: "pending",
    share_quantity: 100,
    share_price: 75.50,
    placed_at: Time.current - 12.hours
  ),

  accepted_medium: BuyOrder.create!(
    business_entity: entities[:real_estate_trust],
    buyer: buyers[:pension_fund],
    status: "accepted",
    share_quantity: 200,
    share_price: 250.00,
    placed_at: Time.current - 15.days,
    processed_at: Time.current - 14.days
  ),

  rejected_medium: BuyOrder.create!(
    business_entity: entities[:restaurant_chain],
    buyer: buyers[:day_trader],
    status: "rejected",
    share_quantity: 25,
    share_price: 45.00,
    placed_at: Time.current - 5.days,
    processed_at: Time.current - 4.days
  ),

  rejected_small: BuyOrder.create!(
    business_entity: entities[:tech_startup],
    buyer: buyers[:small_investor],
    status: "rejected",
    share_quantity: 15,
    share_price: 150.00,
    placed_at: Time.current - 8.days,
    processed_at: Time.current - 7.days
  )
}

puts "Seed completed successfully!"
puts "Created:"
puts "- #{BusinessOwner.count} business owners"
puts "- #{BusinessEntity.count} business entities"
puts "- #{Buyer.count} buyers"
puts "- #{BuyOrder.count} buy orders"
