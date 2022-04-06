class PetApplicationsController < ApplicationController
  def create
    PetApplication.create(application_id: params[:application_id], pet_id: params[:pet_id])
    redirect_to "/applications/#{params[:application_id]}"
  end

  private

  def pet_application_params
    params.permit(:application_id, :pet_id)
  end

  it 'updates status to approved' do
    @application1.update_status_pending
    expect(@application1.status).to eq('Pending')
    @application1.approved
    expect(@application1.status).to eq('Approved')
  end
end
