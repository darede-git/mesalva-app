# frozen_string_literal: true

require 'me_salva/crm/users'
require 'spec_helper'
require './spec/factories/user' unless defined?(User)

describe MeSalva::Crm::Users do
  subject { described_class.new }
  let(:client) { double }
  let!(:user) { FactoryBot.build(:intercom_user) }

  describe '#create' do
    it 'creates a Intercom User' do
      Timecop.freeze(Time.now)
      mock_setup_intercom_user(user, %i[create save])
      allow(Intercom::User).to receive('last_request_at=')
      allow(Intercom::User).to receive('signed_up_at=')
      intercom_user = subject.create(user)

      expect(intercom_user.name).to eq(user.name)
      expect(intercom_user.email).to eq(user.email)
    end
  end

  describe '#update' do
    context 'when updating email and name' do
      it 'updates the intercom user attributes' do
        user.name = 'New name'
        user.email = 'new@email.com'
        mock_setup_intercom_user(user, %i[create save])
        allow(Intercom::User).to receive('last_request_at=')
        updated_user = subject.update(user)

        expect(updated_user.name).to eq('New name')
        expect(updated_user.email).to eq('new@email.com')
      end
    end

    context 'when updating only the email' do
      it 'updates the intercom user email' do
        user.email = 'updated@email.com'
        mock_setup_intercom_user(user, %i[create update save])
        allow(Intercom::User).to receive('last_request_at=')
        updated_user = subject.update(user)

        expect(updated_user.email).to eq('updated@email.com')
        expect(updated_user.name).to eq(user.name)
      end
    end

    context 'when addind custom attributes to an user' do
      it 'adds the attributes to the user' do
        mock_setup_intercom_user(user, %i[create save], 'subscriber' => '1')
        allow(Intercom::User).to receive('last_request_at=')
        updated_user = subject.update(user, subscriber: '1')

        expect(updated_user.custom_attributes).to include('subscriber' => '1')
      end
    end

    context 'when updating custom attributes of an user' do
      it 'adds updates the attributes of the user' do
        mock_setup_intercom_user(user, %i[create save],
                                 'subscriber' => '0',
                                 'sexo' => 'Masculino',
                                 'phone' => '(51)32225222')
        allow(Intercom::User).to receive('last_request_at=')
        updated_user = subject.update(user, subscriber: '0',
                                            sexo: 'Masculino',
                                            phone: '(51)32225222')

        expect(updated_user.custom_attributes)
          .to include('subscriber' => '0',
                      'sexo' => 'Masculino',
                      'phone' => '(51)32225222')
      end
    end
  end
end
