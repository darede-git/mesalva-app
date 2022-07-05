# frozen_string_literal: true

class Teacher::RegistrationsController < BaseRegistrationsController
  before_action -> { authenticate(%w[admin teacher]) }
  before_action :set_resources, only: [:create]
  after_action :update_auth_headers

  def create
    super
  end

  private

  def set_resources
    @resource           = resource_class.new(sign_up_params)
    @resource.provider  = 'email'
    @resource.email     = sign_up_params[:email]
  end
end
