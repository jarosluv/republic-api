class CreateBusinessOwners < ActiveRecord::Migration[8.0]
  def change
    create_table :business_owners do |t|
      t.string :name

      t.timestamps
    end
  end
end
