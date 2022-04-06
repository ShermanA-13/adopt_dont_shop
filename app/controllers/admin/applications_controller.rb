class Admin::ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
  end

  def update
    @application = PetApplication.Application.find(params[:id])
    @application.approved
    redirect_to "/admin/applications/#{@application.id}"
  end

  
end
