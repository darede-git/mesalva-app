# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:invalid_email) { FactoryBot.build(:user, email: '´autocomplete@mobile.com') }
  let(:valid_email) { FactoryBot.build(:user, email: 'auto-complete@mobile.com') }
  let(:valid_email_with_numbers) do
    FactoryBot.build(:user, email: 'auto-complete123@mobile123.test123.com')
  end
  let(:invalid_enem_subscription) { FactoryBot.build(:user, enem_subscription_id: 'batatarosada') }
  let(:valid_enem_subscription) { FactoryBot.build(:user, enem_subscription_id: '012345678911') }

  context 'validations' do
    should_have_many(:cancellation_quizzes, :comments, :accesses,
                     :net_promoter_scores, :scholar_records)
    should_have_one(:address, :academic_info)
    should_belong_to(:objective)

    it { should have_many(:instructor_users) }
    it { should have_many(:instructors).through(:instructor_users) }

    it do
      should validate_inclusion_of(:profile).in_array(%w[student teacher tutor])
    end
    context "subscription enem id" do
      it 'should validate subscription_enem_id format when present' do
        expect(invalid_enem_subscription).to be_invalid
        expect(valid_enem_subscription).to be_valid
      end
    end

    context 'email' do
      it 'should validate email format when present' do
        expect(invalid_email).to be_invalid
        expect(valid_email).to be_valid
        expect(valid_email_with_numbers).to be_valid
      end
    end

    context 'social user' do
      it 'should not invalidate a user with nil email' do
        expect(FactoryBot.build(:user,
                                email: nil,
                                provider: 'facebook')).to be_valid
      end
    end

    context 'email user' do
      it 'should invalidate a user with nil email' do
        expect(FactoryBot.build(:user,
                                email: nil,
                                provider: 'email')).to be_invalid
      end
    end
  end

  describe 'student types' do
    context 'with student types enumerated' do
      it 'should have the right indexes' do
        expect(User::PREMIUM_STATUS[:student_lead]).to eq(0)
        expect(User::PREMIUM_STATUS[:subscriber]).to eq(1)
        expect(User::PREMIUM_STATUS[:unsubscriber]).to eq(2)
        expect(User::PREMIUM_STATUS[:ex_subscriber]).to eq(3)
      end
    end
    context 'with student types mapped' do
      it 'should contain the expected types' do
        expect(User::PREMIUM_STATUS).to include(:student_lead,
                                                :subscriber,
                                                :unsubscriber,
                                                :ex_subscriber)
      end
    end
  end

  describe 'premium user verifications' do
    context 'premium?' do
      context 'with a premium user' do
        let!(:access) { create(:access_expiring_tomorow) }
        it 'should return true' do
          expect(access.user.premium?).to eq(true)
        end
      end
      context 'with a not premium user' do
        let!(:access) { create(:access_expired) }
        it 'should return false' do
          expect(access.user.premium?).to eq(false)
        end
      end
    end
    context 'not_premium?' do
      context 'with a not premium user' do
        let!(:access) { create(:access_expired) }
        it 'should return true' do
          expect(access.user.not_premium?).to eq(true)
        end
      end
      context 'with a premium user' do
        let!(:access) { create(:access_expiring_tomorow) }
        it 'should return false' do
          expect(access.user.not_premium?).to eq(false)
        end
      end
    end
  end

  context '.disable_last_scholar_record' do
    context 'with scholar records' do
      before { create_list(:scholar_record, 2, :with_college, user: user) }

      it 'disables users last scholar record' do
        expect do
          user.disable_last_scholar_record
        end.to change { user.scholar_records.last.active }
          .from(true).to(false)

        expect(user.scholar_records.first.active).to be_truthy
      end
    end

    context 'without scholar records' do
      it 'returns nil' do
        expect(user.disable_last_scholar_record).to eq(nil)
      end
    end
  end

  context '.change_objective?' do
    context 'when a user updates objetive' do
      let(:objective) { create(:objective) }

      it 'returns true' do
        user.update(objective: objective)
        expect(user.change_objective?).to eq(true)
      end
    end

    context 'when a user dont updates objetive' do
      it 'returns false' do
        user.update(name: 'Outro nome')
        expect(user.change_objective?).to eq(false)
      end
    end
  end

  describe 'before save' do
    context 'user has no crm_email' do
      let(:user_without_crm_email) { create(:facebook_user) }
      it 'reflects email to crm_email' do
        user = User.find(user_without_crm_email.id)
        expect(user).to have_attributes(crm_email: user_without_crm_email.email)
      end
    end
    context 'user has crm_email' do
      let(:user_with_crm_email) { create(:facebook_user, crm_email: 'email@email.com') }
      it 'does not reflect email to crm_email' do
        user = User.find(user_with_crm_email.id)
        expect(user).to have_attributes(crm_email: user_with_crm_email.crm_email)
      end
    end
  end

  describe 'birth_date' do
    user = FactoryBot.build(:user)
    context 'birth date is invalid' do
      it 'does not save the user' do
        usuario = User.create(name: user.name,
                              provider: user.provider,
                              uid: user.uid,
                              email: user.email,
                              birth_date: '1800-01-01'.to_date)
        usuario_criado = User.find_by_id(usuario.id)
        expect(usuario_criado).to eq(nil)
      end
    end
    context 'birth date is valid' do
      it 'keeps the birth date informed' do
        usuario = User.create(name: user.name,
                              provider: user.provider,
                              uid: user.uid,
                              email: user.email,
                              birth_date: '1900-01-01'.to_date)
        usuario_criado = User.find_by_id(usuario.id)
        expect(usuario_criado.birth_date).to eq(usuario.birth_date)
      end
    end
    context 'birth date is nil' do
      it 'keeps the birth date nil' do
        usuario = User.create(name: user.name,
                              provider: user.provider,
                              uid: user.uid,
                              email: user.email,
                              birth_date: nil)
        usuario_criado = User.find_by_id(usuario.id)
        expect(usuario_criado.birth_date).to eq(nil)
      end
    end
  end

  describe '::from_omniauth' do
    context 'when user does not exist' do
      context 'when graph data is valid' do
        it 'creates the user' do
          auth = provider_hash('02/26/1994')

          expect do
            User.from_omniauth(auth)
          end.to change(User, :count).by(1)
        end
      end
      context 'when graph data is invalid' do
        it 'does not create the user' do
          auth = provider_hash('2016-09-26')

          expect do
            User.from_omniauth(auth)
          end.to raise_error(ArgumentError, 'invalid date')
        end
      end
    end

    context 'when user exists' do
      let!(:user) do
        create(:user, uid: '104758079989784', provider: 'facebook',
                      facebook_uid: '104758079989784')
      end

      context 'when there is no change in user data' do
        it 'returns the user' do
          expect(User.from_omniauth(provider_hash)).to eq(user)
        end
      end

      context 'when new data is available for the user' do
        it 'updates and returns the user' do
          auth = provider_hash('02/26/1994')
          date = 'Sat, 26 Feb 1994'.to_date
          expect(User.from_omniauth(auth).birth_date).to eq(date)
        end
      end
    end
  end

  def provider_hash(birthday = nil)
    OmniAuth::AuthHash.new('provider' => 'facebook',
                           'uid' => '104758079989784',
                           'email' => '',
                           'info' => { 'name' => 'Darth Vader',
                                       'gender' => 'male',
                                       'birth_date' => birthday })
  end

  describe '#disable_last_study_plan' do
    it 'disables users last study plan' do
      user = FactoryBot.build(:user)
      create_list(:study_plan, 2, user: user, active: true)

      expect(user.disable_last_study_plan).to be_truthy
      expect(user.study_plans.first.active).to be_truthy
      expect(user.study_plans.last.active).to be_falsey
    end
  end

  describe '#reenable_last_study_plan' do
    it 'reenables users last study plan' do
      user = FactoryBot.build(:user)
      create_list(:study_plan, 2, user: user, active: false)

      expect(user.reenable_last_study_plan).to be_truthy
      expect(user.study_plans.first.active).to be_falsey
      expect(user.study_plans.last.active).to be_truthy
    end
  end
end
