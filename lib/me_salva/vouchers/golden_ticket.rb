# frozen_string_literal: true

module MeSalva
  module Vouchers
    class GoldenTicket
      def initialize(platform_slug, package_id = 3099, duration = nil, expires_at = nil)
        @package_id = package_id
        @duration = expires_at.nil? ? duration : expires_to_duration(expires_at)
        @platform = Platform.find_by_slug(platform_slug)
        @created = []
      end

      def create_by_users(users)
        users.map { |user| create_voucher(user) }
      end

      def create_by_quantity(quantity)
        quantity.to_i.times { create_voucher }
        @created
      end

      private

      def expires_to_duration(expires_at)
        (expires_at.to_date - Date.today).to_i
      end

      def rescue_process
        @user_platform = UserPlatform.new(user_id: current_user.id,
                                          platform_id: @platform_voucher.platform_id,
                                          role: 'student', options: @platform_voucher.options)
        save_or_error(@user_platform)

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

      def platform_from_platform_slug(platform_slug)
        return @platform unless platform_slug

        Platform.find_by_slug(platform_slug)
      end

      def create_voucher(user = {})
        email = user["email"] || nil
        options = user["options"] || {}
        platform = platform_from_platform_slug(user["platform_slug"])
        voucher = PlatformVoucher.new(platform: platform, options: options,
                                      duration: @duration, email: email,
                                      package_id: @package_id)

        @created << voucher.save ? trigger_email(voucher) : merge_error(voucher, email)
      end

      def merge_error(voucher, email)
        voucher.errors.as_json.merge(email: email)
      end

      def trigger_email(voucher)
        SendVoucherEmailWorker.perform_async(voucher.token)
        voucher.as_json
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
  end
end
