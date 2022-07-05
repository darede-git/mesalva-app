# frozen_string_literal: true

class Admin::ProfilesController < BaseProfilesController
  wrap_parameters :admin, include: %i[provider
                                      uid
                                      name
                                      nickname
                                      image
                                      email
                                      birth_date
                                      description
                                      active
                                      role]
  before_action -> { authenticate(%w[admin]) }
  before_action :set_resources
  after_action :set_resource_authorization

  def index
    render json: Admin.where(active: true)
                      .where(role_filter)
                      .where(like_filter('name'))
                      .where(like_filter('uid'))
                      .page(page_param)
  end

  def update
    super
  end

  def show
    super
  end

  private

  def role_filter
    return nil if params[:role].nil?

    { role: params[:role] }
  end

  def like_filter(field)
    return nil if params[field].nil?

    ["#{field} ILIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(params[field])}%"]
  end

  def set_resources
    @admin = current_admin
    @resource = find_admin
  end

  def find_admin
    return Admin.find_by_uid(params['uid']) if params['uid']

    current_admin
  end

  def reset_resource
    @resource = @admin if not_the_same_admin
    @resource ||= find_admin
  end

  def not_the_same_admin
    @admin != @resource
  end

  def profile_params
    params.permit(:provider,
                  :uid,
                  :name,
                  :nickname,
                  :image,
                  :email,
                  :birth_date,
                  :description,
                  :active,
                  :role)
  end
end
