class CreateBuyers < ActiveRecord::Migration[8.0]
  def change
    create_table :buyers do |t|
      t.string :name
      t.decimal :available_funds

      t.timestamps
    end
  end
end
