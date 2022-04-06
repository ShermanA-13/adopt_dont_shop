class PetApplication < ApplicationRecord
  belongs_to :pet
  belongs_to :application

  validates :status, presence: true

  attribute :status, :string, default: 'Pending'
end
