# frozen_string_literal: true

class Teacher::ProfilesController < BaseProfilesController
  before_action -> { authenticate(%w[admin teacher]) }
  before_action :unpermitted_action?
  before_action :set_resource
  after_action :set_resource_authorization

  def update
    super
  end

  def show
    super
  end

  private

  def forbidden
    @resource = current_teacher
    render_forbidden
  end

  def unpermitted_action?
    return false if current_admin || self_action?

    forbidden
  end

  def self_action?
    return true unless params['uid']

    params['uid'] == current_teacher.uid if current_teacher
  end

  def valid_params
    %i[provider uid name nickname image email birth_date
       description active]
  end

  def role_params
    %i[name nickname image description birth_date]
  end
end
