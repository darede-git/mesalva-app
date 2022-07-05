# frozen_string_literal: true

module MeSalva
  module Platforms
    class PlatformRolesPermission
      def initialize(user)
        @user = user
      end

      def manager_of_student?(student)
        UserPlatform.joins("INNER JOIN user_platforms platform_admin
                        ON platform_admin.platform_id = user_platforms.platform_id
                        AND platform_admin.role IN ('admin', 'teacher')")
                    .where({ "user_platforms.user_id": student.id,
                             "platform_admin.user_id": @user.id })
                    .count.positive?
      end
    end
  end
end
