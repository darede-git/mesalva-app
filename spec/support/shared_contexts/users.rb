# frozen_string_literal: true

RSpec.shared_context "users" do
  let(:admin) { create(:admin) }
  let(:teacher) { create(:teacher) }
  let(:user_platform) { create(:user_platform) }
  let(:user_platform_session) do
    authentication_headers_for(user_platform.user, user_platform.platform)
  end
  let(:user_platform_admin) { create(:admin_user_platform, platform_id: user_platform.platform_id) }
  let(:user_platform_admin_session) do
    authentication_headers_for(user_platform_admin.user, user_platform_admin.platform)
  end
  let(:user) { create(:user) }
  let(:admin_session) { authentication_headers_for(admin) }
  let(:user_session) { authentication_headers_for(user) }
  let(:teacher_session) { authentication_headers_for(teacher) }
  let(:allowed_role) { 'admin' }
end
