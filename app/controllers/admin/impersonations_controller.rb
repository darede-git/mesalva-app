# frozen_string_literal: true

class Admin::ImpersonationsController < BaseSessionsController
  include SerializationHelper
  before_action -> { authenticate_permalink_access(%w[admin]) }
  before_action :set_resource

  def create
    return not_found unless @resource

    update_auth_headers
    render json: @resource,
           include: %i[education_level objective],
           status: :ok
  end

  private

  def set_resource
    @resource = User.find_by_uid(params[:uid])
  end

  def not_found
    @resource = current_admin
    response.headers.merge!(create_new_auth_token)
    render_not_found
  end
end
