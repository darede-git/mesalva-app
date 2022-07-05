# frozen_string_literal: true

class UserPlatformsController < ApplicationController
  include QueryHelper

  before_action -> { authenticate_permalink_access(%w[teacher admin]) }
  before_action :set_user_platform, only: %i[show update destroy]
  before_action :set_platform_unity, only: %i[update create]

  def index
    @users = users
    render json: @users.page(page_param), status: :ok,
           meta: { users_count: @users_count }, include: %i[platform_unity]
  end

  def create
    creator = MeSalva::Platforms::UserPlatformCreator.new(set_platform)
    creator.create_user(email: create_params[:email], send_mail: create_params[:send_mail],
                        password: create_params[:password], name: create_params[:name])
    creator.create_platform_user(create_params[:role], create_params[:options] || {})
    creator.update_platform_unities(create_params[:platform_unities])
    creator.create_accesses(create_params[:package_ids], expires_at: create_params[:expires_at],
                            duration: create_params[:duration])
    render json: creator.user_platform, status: :created, include: %i[platform_unity platform user]
  end

  def update
    if @user_platform.update(user_platform_params)
      render json: @user_platform, status: :ok
    else
      render_unprocessable_entity(@user_platform.errors.messages)
    end
  end

  def show
    if @user_platform
      render json: serialize(@user_platform, v: 3), status: :ok
    else
      render_not_found
    end
  end

  def destroy
    active = !@user_platform.active
    if @user_platform.update(active: active)
      update_platform_access(active)
      render_no_content
    else
      render_unprocessable_entity(@user_platform.errors.messages)
    end
  end

  private

  def users
    @index_joins = []

    result = UserPlatform.where(user_name_filter)
                         .where(user_email_filter)
                         .where(role_filter)
                         .where(platform_filter)
                         .where(unity_filter)
                         .where(active_filter)
                         .joins(@index_joins)

    @users_count = result.count
    result
  end

  def active_filter
    return nil unless params[:active].present?

    { active: params[:active] != 'false' }
  end

  def user_name_filter
    return nil if params[:name].nil?

    set_user_join
    snt_sql(["users.name ILIKE ?", "%#{params['name']}%"])
  end

  def user_email_filter
    return nil if params[:email].nil?

    set_user_join
    snt_sql(["users.email ILIKE ?", "%#{params['email']}%"])
  end

  def role_filter
    return nil if params[:role].nil?

    snt_sql(["role = ?", params['role'].to_s])
  end

  def set_user_join
    return nil if @user_joined

    @index_joins << "LEFT JOIN users ON users.id = user_platforms.user_id"
    @user_joined = true
  end

  def platform_filter
    return nil unless params[:platform_slug].present? || current_platform

    @index_joins << "LEFT JOIN platforms ON platforms.id = user_platforms.platform_id"

    platform_slug = params[:platform_slug] || current_platform.slug
    { "platforms.slug": platform_slug }
  end

  def unity_filter
    return nil unless params[:platform_unity_id].present?

    { platform_unity_id: params[:platform_unity_id] }
  end

  def platform_id
    return Platform.find_by_slug(params[:platform_slug]).id if params[:platform_slug].present?

    return current_platform.id if current_platform

    nil
  end

  def update_platform_access(active = false)
    Access.where(user_id: @user_platform.user_id,
                 platform_id: @user_platform.platform_id).update_all(active: active)
  end

  def set_user_platform
    @user_platform = UserPlatform.find_by_token(params[:id])
    render_not_found unless from_current_platform || super_admin?
  end

  def from_current_platform
    return true if match_user_platform

    @user_platform&.platform == current_platform
  end

  def match_user_platform
    params[:platform_slug].present? && @user_platform&.platform&.slug == params[:platform_slug]
  end

  def update_access(package)
    return nil if update_current_access(package)

    access_options = { gift: true, duration: params[:duration],
                       expires_at: params[:expires_at], platform_id: @platform.id }
    save_or_errors(MeSalva::User::Access.new.create(@user, package, access_options))
  end

  def update_current_access(package)
    access = Access.where(user_id: @user.id, package_id: package.id, platform_id: @platform.id).last
    access = Access.where(user_id: @user.id, package_id: package.id).last if access.nil?

    return false if access.nil?

    access.active = true
    access.expires_at = Time.now + 365.to_i.days # TODO: resolver isso pelos params
    access.essay_credits = package.essay_credits unless package.essay_credits.nil?
    unless package.private_class_credits.nil?
      access.private_class_credits = package.private_class_credits
    end
    access.save
  end

  def set_platform
    return @platform = current_platform if params[:platform_slug].nil?

    @platform = Platform.find_by_slug(params[:platform_slug])
  end

  def save_or_errors(entity)
    @errors = entity.errors.messages unless entity.save
    entity
  end

  def create_admin
    return nil unless params[:essay_corrector]

    admin = Admin.find_by_email(params[:email])
    admin = Admin.create(name: params[:name], email: params[:email]) if admin.nil?
    admin.encrypted_password = @user.encrypted_password
    save_or_errors(admin)
  end

  def user_params
    params.permit(:name, :email, :uid, :password)
          .merge(uid: params[:email])
  end

  def update_old_user
    if no_password?
      @user.password = params[:password]
      @user.save
    end
    send_access_granted_mail
    @user
  end

  def no_password?
    @user.encrypted_password.nil? || @user.encrypted_password.empty?
  end

  def send_account_created_mail
    return nil unless send_mail

    PlatformMailer.platform_account_created(
      email: params[:email], password: params[:password],
      platform_slug: @platform.slug, user: @user
    ).deliver
  end

  def send_access_granted_mail
    return nil unless send_mail

    PlatformMailer.platform_access_granted(email: params[:email], user: @user,
                                           platform_slug: @platform.slug).deliver
  end

  def mail_params
    params.permit(:email, :password, :platform_slug)
  end

  def send_mail
    params[:send_mail].present? && params[:send_mail]
  end

  def user_platform_params
    params.permit(:role, :active, :platform_unity_id, options: {})
  end

  def set_platform_unity
    return unless params[:platform_unity_id].present?

    @platform_unity = PlatformUnity.find(params[:platform_unity_id])
  end

  def platform_unity?
    @platform_unity.present?
  end

  def create_params
    params.permit(:email, :send_mail, :password, :name, :role,
                  :platform_unities, :package_ids, :expires_at, :duration, options: {})
  end
end
