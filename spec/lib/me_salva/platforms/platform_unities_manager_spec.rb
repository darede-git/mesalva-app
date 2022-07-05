# frozen_string_literal: true

describe MeSalva::Platforms::PlatformUnitiesManager do
  let(:platform) { create(:platform) }
  subject { described_class.new(platform) }

  context '#grant_user_to_unities_by_name(user, unity_names)' do
    let(:unity_a) { create(:platform_unity, platform: platform, name: 'Unidade A') }
    let!(:unity_a1) do
      create(:platform_unity, platform: platform, ancestry: unity_a.id.to_s, name: 'Unidade A-1')
    end
    let!(:unity_a2) do
      create(:platform_unity, platform: platform, ancestry: unity_a.id.to_s, name: 'Unidade A-2')
    end

    let(:user_platform) { create(:user_platform, platform: platform, platform_unity: unity_a1) }

    context 'when destiny unity exists' do
      it 'should update user platform' do
        expect(user_platform.platform_unity_id).to eq(unity_a1.id)
        subject.grant_user_to_unities_by_name(user_platform.user, 'Unidade A/Unidade A-2')
        expect(user_platform.reload.platform_unity_id).to eq(unity_a2.id)
      end
    end
    context 'when destiny unity don`t exists' do
      it 'should update user platform' do
        expect(user_platform.platform_unity_id).to eq(unity_a1.id)
        subject.grant_user_to_unities_by_name(user_platform.user, 'Unidade A/Unidade A-3')
        expect(user_platform.reload.platform_unity_id).not_to eq(unity_a1.id)
        expect(user_platform.platform_unity.name).to eq('Unidade A-3')
      end
    end
  end
end
