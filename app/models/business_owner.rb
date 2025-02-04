class BusinessOwner < ApplicationRecord
  has_many :business_entities, inverse_of: :business_owner, dependent: :restrict_with_exception

  validates :name, length: { minimum: 2 }
end
