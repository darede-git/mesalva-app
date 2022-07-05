# frozen_string_literal: true

class Teacher::SessionsController < BaseSessionsController
  before_action :set_resource, only: [:create]

  def create
    super
  end

  def destroy
    super
  end

  private

  def set_resource
    @resource = Teacher.find_for_authentication(email: resource_params[:email])
  end
end
