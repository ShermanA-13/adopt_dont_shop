class Admin::ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
  end

  def update
    @pet_application = PetApplication.find(params[:id])
    @pet_application.update(status: params[:status])
    @pet_application.save
    redirect_to "/admin/applications/#{@pet_application.application.id}"
  end
end
