require 'rails_helper'

RSpec.describe 'admin::application#show page' do
  before do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @application1 = Application.create(
      name: 'The Original Sherman',
      address: '123 Main St', city: 'Longmont', state: 'CO', zipcode: '80501',
      description: '  ', status: 'Pending'
    )
    @application2 = Application.create(
      name: 'Sherman1',
      address: '123 Main St', city: 'Longmont', state: 'CO', zipcode: '80501',
      description: '   ', status: 'Pending'
    )
    @application3 = Application.create(
      name: 'Sherman2',
      address: '123 Main St', city: 'Longmont', state: 'CO', zipcode: '80501',
      description: ' '
    )
    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)
    @pet_5 = @shelter_2.pets.create(name: 'Clawdias', breed: 'shorthair', age: 3, adoptable: true)

    @pet_app_1 = PetApplication.create!(pet_id: @pet_1.id, application_id: @application1.id)
    @pet_app_2 = PetApplication.create!(pet_id: @pet_3.id, application_id: @application1.id)
    @pet_app_3 = PetApplication.create!(pet_id: @pet_5.id, application_id: @application2.id)

    visit "/admin/applications/#{@application1.id}"
  end

  it 'every pet on application has button to approve status and redirects back to admin application show page if clicked' do
    expect(page).to have_button("Approve #{@pet_1.name}")
    expect(page).to have_button("Approve #{@pet_3.name}")
    expect(page).to_not have_button("Approve #{@pet_5.name}")
    click_button "Approve #{@pet_1.name}"
    expect(current_path).to eq("/admin/applications/#{@application1.id}")
    expect(page).to_not have_button("Approve #{@pet_1.name}")
    expect(page).to have_content("Approved Pets: #{@pet_1.name}")
  end

  it 'denies pets if deny button is clicked and indication shows pet has been denied' do
    expect(page).to have_button("Deny #{@pet_3.name}")
    click_button("Deny #{@pet_3.name}")
    expect(current_path).to eq("/admin/applications/#{@application1.id}")
    expect(page).to_not have_button("Deny #{@pet_3.name}")
    expect(page).to have_content("Denied Pets: #{@pet_3.name}")
  end

  it 'approved or denied pets on one application do not affect another application' do
    click_button "Approve #{@pet_1.name}"
    expect(page).to have_content("Approved Pets: #{@pet_1.name}")
    visit "/admin/applications/#{@application2.id}"
    save_and_open_page
    expect(page).to have_button("Approve #{@pet_5.name}")
    expect(page).to have_button("Deny #{@pet_5.name}")
    expect(page).to_not have_button("Approve #{@pet_1.name}")
    expect(page).to_not have_content("Approved pets: #{@pet_1.name}")
  end
end
