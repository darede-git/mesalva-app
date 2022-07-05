# frozen_string_literal: true

class Admin::SessionsController < BaseSessionsController
  before_action :set_resource, only: [:create]

  def create
    super
  end

  def destroy
    super
  end

  private

  def set_resource
    @resource = Admin.find_for_authentication(email: resource_params[:email])
  end
end
