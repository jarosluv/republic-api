class AddMissingIndexes < ActiveRecord::Migration[8.0]
  def change
    add_index :buyers, :name, unique: true
    add_index :business_entities, [ :business_owner_id, :name ], unique: true
  end
end
