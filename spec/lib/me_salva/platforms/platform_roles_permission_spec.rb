# frozen_string_literal: true

describe MeSalva::Platforms::PlatformRolesPermission do
  context 'as signed user' do
    context '#manager_of_student?' do
      context 'with a valid student' do
        let!(:student) { create(:user) }
        let!(:platform) { create(:platform) }
        let!(:student_user_platform) do
          create(:user_platform, platform: platform,
                                 user: student, role: 'student')
        end

        context 'with admin with same platform of user' do
          let!(:admin) { create(:user) }
          let!(:admin_user_platform) do
            create(:user_platform, platform: platform,
                                   user: admin, role: 'admin')
          end
          it 'should allow admin to manage student' do
            expect(described_class.new(admin).manager_of_student?(student)).to eq(true)
          end
        end

        context 'with admin of different platform of user' do
          let!(:platform2) { create(:platform) }
          let!(:admin) { create(:user) }
          let!(:admin_user_platform) do
            create(:user_platform, platform: platform2,
                                   user: admin, role: 'admin')
          end
          it 'should deny admin to manage student' do
            expect(described_class.new(admin).manager_of_student?(student)).to eq(false)
          end
        end

        context 'with student trying to manage student' do
          let!(:student2) { create(:user) }
          let!(:admin_user_platform) do
            create(:user_platform, platform: platform,
                                   user: student2, role: 'student')
          end
          it 'should deny' do
            expect(described_class.new(admin).manager_of_student?(student)).to eq(false)
          end
        end
      end
    end
  end
end
