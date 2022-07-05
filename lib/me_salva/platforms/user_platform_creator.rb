# frozen_string_literal: true

module MeSalva
  module Platforms
    class UserPlatformCreator
      def initialize(platform)
        @platform = platform
      end

      def create_user(**attr)
        @user = ::User.find_by_email(attr[:email])
        @send_mail = attr[:send_mail] == true
        return update_old_user(attr[:password]) unless @user.nil?

        @user = ::User.create(name: attr[:name], email: attr[:email],
                              uid: attr[:uid], password: attr[:password])
        send_account_created_mail(attr[:password])
        @user
      end

      def create_platform_user(role = 'student', options = {})
        return nil if update_current_user_platform(options)

        @user_platform = UserPlatform.create(user_id: @user.id,
                                             platform_id: @platform.id,
                                             role: role,
                                             options: options)
      end

      def update_platform_unities(platform_unities)
        return nil if platform_unities.blank?

        platform_unity_manager = MeSalva::Platforms::PlatformUnitiesManager.new(@platform)
        platform_unity_manager.grant_user_to_unities_by_name(@user, platform_unities)
      end

      def create_accesses(package_ids, **attr)
        package_ids.to_s.split(',').each do |package_id|
          package = Package.find(package_id.strip)
          update_access(package, attr)
        end
      end

      attr_reader :user_platform

      private

      def update_current_user_platform(options)
        @user_platform = UserPlatform.where(user_id: @user.id, platform_id: @platform.id).first
        return false if @user_platform.nil?

        @user_platform.update(active: true, options: options)
      end

      def update_access(package, attr)
        return nil if update_current_access(package, attr)

        access_options = { gift: true, duration: attr[:duration],
                           expires_at: attr[:expires_at], platform_id: @platform.id }
        MeSalva::User::Access.new.create(@user, package, access_options)
      end

      def update_current_access(package, attr)
        access = Access.where(user_id: @user.id,
                              package_id: package.id,
                              platform_id: @platform.id)
                       .last
        access = Access.where(user_id: @user.id, package_id: package.id).last if access.nil?

        return false if access.nil?

        access.active = true
        access.expires_at = attr[:expires_at] || (Time.now + attr[:duration].to_i.days)
        access.essay_credits = package.essay_credits unless package.essay_credits.nil?
        unless package.private_class_credits.nil?
          access.private_class_credits = package.private_class_credits
        end
        access.save
      end

      def update_old_user(password)
        if no_password?
          @user.password = password
          @user.save
        end
        send_access_granted_mail if @send_mail
        @user
      end

      def send_account_created_mail(password)
        PlatformMailer.platform_account_created(email: @user.email, password: password,
                                                platform_slug: @platform.slug, user: @user).deliver
      end

      def send_access_granted_mail
        PlatformMailer.platform_access_granted(email: @user.email,
                                               user: @user,
                                               platform_slug: @platform.slug)
                      .deliver
      end

      def no_password?
        @user.encrypted_password.blank?
      end
    end
  end
end
