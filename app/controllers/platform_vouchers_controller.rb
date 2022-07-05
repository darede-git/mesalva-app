# frozen_string_literal: true

class PlatformVouchersController < ApplicationController
  before_action -> { authenticate_permalink_access(%w[admin]) }, except: :rescue
  before_action -> { authenticate(%w[user]) }, only: :rescue
  before_action :set_platform, only: %i[create_many]
  before_action :set_platform_voucher, only: %i[rescue show destroy update]

  def create_many
    @created = if platform_params[:quantity].nil?
                 voucher_creator.create_by_users(platform_params[:users])
               else
                 voucher_creator.create_by_quantity(platform_params[:quantity])
               end

    render_created(@created)
  end

  def rescue
    return render_used_voucher if @platform_voucher.user_id?
    return render_unauthorized if wrong_user

    rescue_process

    @platform_voucher.update_columns(user_id: current_user.id)

    render_created(@user_platform)
  end

  private

  def page
    params['page'] || 1
  end

  def set_platform
    render_not_found unless params[:platform_slug].present?
    set_security_user_platform(%w[teacher admin user])
  end

  def platform_voucher_params
    new_platform = Platform.find_by_slug(params[:new_platform_slug])

    update_params = params.permit(:email, :duration)
    update_params.merge!(platform_id: new_platform.id) if new_platform
    update_params
  end

  def platform_vouchers
    PlatformVoucher.vouchers_by_platform(params['platform_slug'])
                   .email_eq(params['email'])
                   .duration_eq(params['duration'])
                   .vouchers_by_package(params['package_slug'])
  end

  def voucher_creator
    MeSalva::Vouchers::GoldenTicket.new(platform_params[:platform_slug],
                                        platform_params[:package_id],
                                        platform_params[:duration])
  end

  def rescue_process
    platform_unities = @platform_voucher.options['platform_unities']
    options = @platform_voucher.options.tap { |hs| hs.delete('platform_unities') }
    @user_platform = UserPlatform.new(user_id: current_user.id, role: 'student',
                                      platform_id: @platform_voucher.platform_id,
                                      options: options)
    save_or_error(@user_platform)

    @user_platform.grant_unities_by_names(platform_unities) unless platform_unities.nil?

    grant_access
  end

  def save_or_error(entity)
    render json: entity.errors.as_json, status: :precondition_failed unless entity.save
  end

  def grant_access
    @access = Access.new(user_id: current_user.id, package_id: @platform_voucher.package_id,
                         starts_at: Time.now, active: true, created_by: 'voucher',
                         expires_at: (Time.now + @platform_voucher.duration.to_i.days),
                         platform_id: @platform_voucher.platform_id, gift: true)
    save_or_error(@access)
  end

  def set_platform_voucher
    @platform_voucher = PlatformVoucher.find_by_token(params[:token])
    @platform_voucher ||= PlatformVoucher.where(email: current_user.email, user_id: nil).first
    render_unauthorized unless @platform_voucher
  end

  def platform_params
    params.permit(:package_id, :platform_slug, :quantity,
                  :duration, users: [:email, :platform_slug, { options: {} }])
  end

  def wrong_user
    return false unless @platform_voucher.email

    @platform_voucher.email != current_user.email
  end

  def render_used_voucher
    return render_unauthorized if wrong_user

    @user_platform = UserPlatform.where(user_id: current_user.id,
                                        platform_id: @platform_voucher.platform_id).take
    render_ok(@user_platform)
  end
end
