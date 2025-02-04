class AddExtraTimestampsToBuyOrder < ActiveRecord::Migration[8.0]
  def change
    add_column :buy_orders, :placed_at, :datetime, null: false
    add_column :buy_orders, :processed_at, :datetime
  end
end
