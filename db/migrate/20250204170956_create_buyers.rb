class CreateBuyers < ActiveRecord::Migration[8.0]
  def change
    create_table :buyers do |t|
      t.string :name
      t.decimal :available_funds, precision: 12, scale: 2, default: 0, null: false

      t.timestamps
    end
  end
end
