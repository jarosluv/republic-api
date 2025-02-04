class CreateBuyOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :buy_orders do |t|
      t.references :business_entity, null: false, foreign_key: true
      t.references :buyer, null: false, foreign_key: true
      t.string :status, null: false, default: "pending", index: true
      t.integer :share_quantity
      t.decimal :share_price

      t.timestamps
      t.index %i[business_entity_id buyer_id]
    end
  end
end
