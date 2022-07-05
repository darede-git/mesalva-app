# frozen_string_literal: true

module MeSalva
  module Platforms
    class PlatformUnitiesManager
      def initialize(platform)
        @platform = platform
      end

      def grant_user_to_unities_by_name(user, unity_names, user_platform = nil)
        @user_platform = user_platform
        @user = user
        parsed_unity_names = unity_names.split('/').map(&:strip).select{|name| name.blank? == false}
        platform_unity_id = nil
        while (next_unity_name = parsed_unity_names.slice!(0))
          next_unity = set_next_unity(platform_unity_id, next_unity_name)
          platform_unity_id = next_unity.id
        end

        update_user_platforms(platform_unity_id) unless platform_unity_id.nil?
      end

      private

      def update_user_platforms(platform_unity_id)
        return @user_platform.update(platform_unity_id: platform_unity_id) unless @user_platform.nil?

        UserPlatform.where(user: @user, platform: @platform)
                    .update_all(platform_unity_id: platform_unity_id)
      end

      def set_next_unity(unity_id, unity_name)
        if unity_id.nil?
          next_unity = root_unity_by_name(unity_name)
          return next_unity unless next_unity.nil?

          PlatformUnity.create(platform_id: @platform.id, name: unity_name)
        end

        next_unity = unity_by_parent_and_name(unity_id, unity_name)

        return next_unity unless next_unity.nil?

        PlatformUnity.create(platform_id: @platform.id,
                             parent_id: unity_id, name: unity_name)
      end

      def unity_by_parent_and_name(parent_unity_id, name)
        platform_unity(name).by_parent_id(parent_unity_id).first
      end

      def root_unity_by_name(name)
        platform_unity(name).root_only(true).first
      end

      def platform_unity(name)
        PlatformUnity.by_platform_id(@platform.id)
                     .where('name ILIKE :name', name: "%#{name}%")
      end
    end
  end
end
