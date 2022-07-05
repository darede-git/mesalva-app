# frozen_string_literal: true

require 'me_salva/platforms/user_platforms_remover'

describe MeSalva::Platforms::UserPlatformRemover do
  let(:platform) { create(:platform) }
  subject { described_class.new(platform) }

  context '#remove_user' do
    let(:user_platform) { create(:user_platform, platform: platform) }
    let(:access) do
      create(:access_with_duration_and_node, user: user_platform.user, platform_id: platform.id)
    end
    it 'inactivate all accesses for a user' do
      subject.remove_user(access.user)
      expect_active_as(false, access, user_platform)
    end
  end

  context '#remove_user_list' do
    let(:user_platform_1) { create(:user_platform, platform: platform) }
    let(:user_platform_2) { create(:user_platform, platform: platform) }
    let!(:access_1_up_1) do
      create(:access_with_duration_and_node, user: user_platform_1.user, platform_id: platform.id)
    end
    let!(:access_2_up_1) do
      create(:access_with_duration_and_node, user: user_platform_1.user, platform_id: platform.id)
    end
    let!(:access_1_up_2) do
      create(:access_with_duration_and_node, user: user_platform_2.user, platform_id: platform.id)
    end
    let(:user_list) { [access_1_up_1.user, access_1_up_2.user] }
    it "inactivate all access for all users in a list" do
      subject.remove_user_list(user_list)
      expect_active_as(false,
                       access_1_up_1,
                       access_2_up_1,
                       access_1_up_2,
                       user_platform_1,
                       user_platform_2)
    end
  end

  context 'remove_all' do
    let(:user_platform) { create(:user_platform, platform: platform) }
    let(:user_platform1) { create(:user_platform, platform: platform) }
    let(:access) do
      create(:access_with_duration_and_node,
             user: user_platform.user, platform_id: platform.id)
    end
    let(:access1) do
      create(:access_with_duration_and_node,
             user: user_platform1.user, platform_id: platform.id)
    end

    it 'inactivate all access for all users of a platform' do
      expect_active_as(true, access, access1, user_platform, user_platform1)
      subject.remove_all
      expect_active_as(false, access, access1, user_platform, user_platform1)
    end
  end

  def expect_active_as(active, *models)
    models.map do |model|
      model.reload
      expect(model.active).to eq(active)
    end
  end
end
