class PetApplication < ApplicationRecord
  belongs_to :pet
  belongs_to :application
  attribute :status, :string, default: 'Pending'

  def approved
    update({ status: 'Approved' })
  end
end
