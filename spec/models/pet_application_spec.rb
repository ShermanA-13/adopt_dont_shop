 require 'rails_helper'

RSpec.describe PetApplication do
  before do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @application1 = Application.create(
      name: 'The Original Sherman',
      address: '123 Main St', city: 'Longmont', state: 'CO', zipcode: '80501',
      description: '  ', status: 'Pending'
    )
    PetApplication.create!(pet_id: @pet_1.id, application_id: @application1.id)
  end

  describe 'relationships' do
    it { should validate_presence_of(:status)}
    it { should belong_to(:pet) }
    it { should belong_to(:application) }
  end

  it 'can update PetApplication Status' do
    visit "/admin/applications/#{@application1.id}"
    require "pry"; binding.pry
    click_button "Approve"
    expect(@application1.pet_application.status).to eq()
  end
end
