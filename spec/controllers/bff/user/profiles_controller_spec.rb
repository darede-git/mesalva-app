# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bff::User::ProfilesController, type: :controller do
  describe 'GET #full' do
    let!(:default_enem_role) { create(:role, slug: 'padrao-enem', role_type: 'persona') }
    let!(:default_med_role) { create(:role, slug: 'padrao-med', role_type: 'persona') }
    context 'as user without accesses' do
      let(:role) { create(:role) }
      before do
        user_session
        user.update(birth_date: '2000-01-01',
                    enem_subscription_id: '0000000000',
                    phone_area: '00',
                    phone_number: '999999999')
        user.reload
        UserRole.create(user: user, role: role)
      end
      let!(:user_setting) do
        create(:user_setting,
               user: user,
               key: 'test_key',
               value: { some: 'value' })
      end

      it 'should returns complete user' do
        get :full
        user_result = parsed_response['results']['user']
        expect(user_result).to eq({ "birth_date" => user.birth_date,
                                    "email" => user.email,
                                    "enem_subscription_id" => user.enem_subscription_id,
                                    "image" => nil,
                                    "name" => user.name,
                                    "guest" => false,
                                    "phone" => user.phone,
                                    "persona" => { "brand_image" => nil, "name" => "User 1", "slug" => "padrao-enem" },
                                    "roles" => [{ "name" => role.name, "slug" => role.slug }],
                                    "settings" => {
                                      "onboarding" => { "accepted" => false, "current_step" => 0, "finished" => false },
                                      user_setting.key.to_s => user_setting.value
                                    },
                                    "token" => user.token, "uid" => user.uid })
      end

      it 'should returns no access' do
        get :full
        user_result = parsed_response['results']['accesses']
        expect(user_result).to eq({ "essay_credits" => 0,
                                    "essay_unlimited" => false,
                                    "has" => false,
                                    "essay" => false,
                                    "onboarding_pending" => true,
                                    "role_slugs" => [role.slug],
                                    "course_class_labels" => [],
                                    "remaining_days" => 0,
                                    "course_class" => false })
      end
    end
    context 'as user with accesses' do
      before { user_session }
      let!(:feature1) do
        create(:feature,
               name: 'Plano de Estudos',
               token: 'study_plan')
      end

      let!(:pack1) do
        create(:package_with_price_attributes,
               label: ['turma-1'],
               feature_ids: [feature1.id])
      end

      let!(:access1) do
        create(:access,
               user: user,
               expires_at: Date.tomorrow,
               package: pack1)
      end

      let!(:feature2) do
        create(:feature,
               name: 'Redação Personalizada',
               token: 'personal_correction',
               category: 'essay')
      end

      let!(:pack2) do
        create(:package_with_price_attributes,
               label: %w[turma-2 turma-3],
               feature_ids: [feature2.id])
      end

      let!(:access2) do
        create(:access,
               user: user,
               expires_at: Date.today + 5.days,
               package: pack2)
      end

      it 'should returns complete access' do
        get :full
        user_result = parsed_response['results']['accesses']
        expect(user_result).to eq({ "essay_credits" => 20,
                                    "essay_unlimited" => false,
                                    "has" => true,
                                    "essay" => true,
                                    "onboarding_pending" => true,
                                    "role_slugs" => [],
                                    "course_class_labels" => %w[turma-1 turma-2 turma-3],
                                    "remaining_days" => 5,
                                    "study_plan" => true,
                                    "course_class" => true,
                                    "essay_personal_correction" => true })
      end

      context 'with unlimited essay credits' do
        let!(:pack3) do
          create(:package_with_price_attributes,
                 label: ['turma-1'], unlimited_essay_credits: true)
        end
        let!(:access3) do
          create(:access, user: user, expires_at: Date.today + 5.days, package: pack3)
        end
        it 'should returns complete access' do
          get :full
          user_result = parsed_response['results']['accesses']
          expect(user_result['essay']).to eq(true)
          expect(user_result['essay_unlimited']).to eq(true)
        end
      end
    end
  end
end
