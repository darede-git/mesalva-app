# frozen_string_literal: true

module MeSalva
  module Platforms
    class UserPlatformRemover
      def initialize(platform)
        @platform = platform
      end

      def remove_user_list(user_list)
        user_list.each { |user| remove_user(user) }
      end

      def remove_user(user)
        remove_accesses(user) if user_has_accesses?(user)
        remove_from_platform(user)
      end

      def remove_all
        remove_all_accesses
        remove_all_user_plaform
      end

      private

      def remove_accesses(user)
        user.accesses.each do |access|
          inactivate_access(access) if access_active?(access)
        end
      end

      def remove_from_platform(user)
        user.user_platforms.each do |user_platform|
          inactivate_user_platform(user_platform) if correct_platform?(user_platform)
        end
      end

      def inactivate_access(access)
        access.active = false
        access.save
      end

      def inactivate_user_platform(user_platform)
        user_platform.active = false
        user_platform.save
      end

      def access_active?(access)
        access.active
      end

      def correct_platform?(user_platform)
        user_platform.platform_id == @platform.id
      end

      def user_has_accesses?(user)
        user.accesses.count.positive?
      end

      def remove_all_user_plaform
        UserPlatform.where(platform_id: @platform.id).update(active: false)
      end

      def remove_all_accesses
        Access.where(platform_id: @platform.id).update(active: false)
      end
    end
  end
end
