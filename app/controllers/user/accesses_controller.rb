# frozen_string_literal: true

class User::AccessesController < ApplicationController
  include UserAccessHelper

  before_action :set_access, only: :update
  before_action -> { authenticate(%w[admin teacher user]) }, only: :index
  before_action -> { authenticate(%w[admin]) }, only: %i[update create]
  before_action :authenticate_permission, only: :full

  def index
    render json: serialize(accesses, options), status: :ok
  end

  def create
    return render_unprocessable_entity unless valid_create_param?

    access = create_access(user_by_uid, package,
                           duration: params['duration'],
                           created_by: current_admin.uid,
                           gift: true)
    if access.save
      render_created(access)
    else
      render_unprocessable_entity(access.errors)
    end
  end

  def update
    if update_or_freeze_access
      render_ok(@access)
    else
      render_unprocessable_entity(@access.errors)
    end
  end

  def full
    accesses = Access.by_user_active_in_range(current_user.id)
    declaring_full_variavel

    sweep_accesses(accesses)

    features = Feature.all
    @result = {
      access: { has: accesses.count.positive?, duration: @duration }
    }
    sweep_features(features)

    @result['essay']['credits'] = @essay_credits
    @result['essay']['unlimited'] = @unlimited_essay_credits

    render json: @result
  end

  private

  def declaring_full_variavel
    @duration = 0
    @essay_credits = 0
    @unlimited_essay_credits = false
    @user_feature_ids = []
  end

  def sweep_accesses(accesses)
    accesses.each do |access|
      @days_remaining = access.full_remaining_days.to_i
      @duration = @days_remaining if @days_remaining > @duration
      @essay_credits += access.package.essay_credits
      @unlimited_essay_credits |= access.package.unlimited_essay_credits

      @user_feature_ids.concat(access.package.feature_ids)
    end
  end

  def sweep_features(features)
    features.each { |feature| sweep_feature(feature) }
  end

  def sweep_feature(feature)
    has = @user_feature_ids.include?(feature.id)

    return sweep_category_feature(feature, has) if feature.category

    @result[feature.token] = { has: has }
  end

  def sweep_category_feature(feature, has)
    @result[feature.category] = { has: has } if @result[feature.category].nil?
    @result[feature.category][feature.token] = has
    @result[feature.category][:has] |= has
  end

  def valid_create_param?
    params['package_id'] && params['user_uid'] && params['duration']
  end

  def update_or_freeze_access
    return @access.freeze if freeze?
    return @access.unfreeze if unfreeze?

    @access.update(access_params)
  end

  def freeze?
    params['freeze']
  end

  def unfreeze?
    params['unfreeze']
  end

  def accesses
    return Access.by_user(user_by_uid) if admin_with_user_filter

    return Access.where(user: user_by_email, platform_id: platform.id) if platform_access?

    accesses_by_current_user if user_signed_in?
  end

  def platform_access?
    return false unless platform.present? && params[:user_email].present?

    MeSalva::Platforms::PlatformRolesPermission.new(current_user)
                                               .manager_of_student?(user_by_email)
  end

  def platform
    @platform ||= Platform.find_by_slug(params[:platform_slug]) if params[:platform_slug].present?

    @platform ||= current_platform
  end

  def accesses_by_current_user
    return Access.by_user_active_in_range(current_user) if param_valid?

    Access.by_user(current_user)
  end

  def param_valid?
    params['valid'] == 'true'
  end

  def admin_with_user_filter
    params['user_uid'] && admin_signed_in?
  end

  def package
    @package ||= Package.find params['package_id']
  end

  def user_by_uid
    @user_by_uid ||= User.find_by_uid(params['user_uid'])
  end

  def user_by_email
    @user_by_email ||= User.find_by_email(params[:user_email])
  end

  def set_access
    @access = Access.find(params[:id])
  end

  def access_params
    params.permit(:user_id, :order_id, :package_id,
                  :starts_at, :expires_at, :active,
                  :essay_credits, :private_class_credits)
  end

  def options
    { include: %i[package package.features] }
  end
end
