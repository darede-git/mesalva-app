# frozen_string_literal: true

describe MeSalva::Platforms::UserPlatformCreator do
  let(:platform) { create(:platform) }
  subject { described_class.new(platform) }

  context 'When have no email registered' do
    it 'should create a new user' do
      email = 'some@email.com'
      name = 'SomeName'
      expect do
        created_user = subject.create_user(email: email, send_email: true,
                                           password: 'SomePassword', name: name)
        expect(created_user.email).to eq(email)
        expect(created_user.name).to eq(name)
      end.to change(User, :count).by(1)
    end
  end
  context 'When already have user with the email' do
    let(:email) { 'some2@email.com' }
    let!(:user) { create(:user, email: email) }
    it 'should use the same user' do
      expect do
        subject.create_user(email: email, send_email: true,
                            password: 'SomePassword', name: 'SomeName')
      end.to_not change(User, :count)
    end
  end

  context 'With first step created' do
    before do
      subject.create_user(email: 'some@email', send_email: true,
                          password: 'SomePassword', name: 'Some name')
    end

    it 'should create a user_platform with right role and options' do
      user_platform = subject.create_platform_user('teacher', { some: 'option' })
      expect(user_platform.role).to eq('teacher')
      expect(user_platform.options).to eq({ "some" => 'option' })
    end
  end

  context 'With second step created' do
    before do
      subject.create_user(email: 'some@email', send_email: true,
                          password: 'SomePassword', name: 'Some name')
      subject.create_platform_user('student')
    end

    it 'should create a user_platform with right role and options' do
      expect do
        subject.update_platform_unities('Unity 1/Unity 1a')
      end.to change(PlatformUnity, :count).by(2)
    end
  end
end
