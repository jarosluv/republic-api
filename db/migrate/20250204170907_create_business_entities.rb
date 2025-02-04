class CreateBusinessEntities < ActiveRecord::Migration[8.0]
  def change
    create_table :business_entities do |t|
      t.references :business_owner, null: false, foreign_key: true
      t.string :name
      t.integer :available_shares
      t.decimal :share_price

      t.timestamps
    end
  end
end
