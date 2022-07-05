# frozen_string_literal: true

require 'spec_helper'

describe MeSalva::Crm::Rdstation::Users do
  let(:new_contacts) { double }
  before do
    new_auth = double
    allow(MeSalva::Crm::Rdstation::Authentication).to receive(:new).and_return(new_auth)
    allow(new_auth).to receive(:access_token).and_return(access_token)

    allow(RDStation::Contacts).to receive(:new).with(new_auth.access_token).and_return(new_contacts)
    allow(new_contacts).to receive(:by_email).with(current_user['email']).and_return(rdstation_user)
    allow(rdstation_user).to receive(:update).with(current_user.options['new_email'])
  end
  let(:access_token) do
    JSON.parse(File.read('spec/fixtures/rdstation/authentication_response.json'))['access_token']
  end
  let(:rdstation_user) do
    JSON.parse(File.read('spec/fixtures/rdstation/user_email.json'))
  end
  let(:current_user) { FactoryBot.build(:user, options: { 'new_email': 'new@email.com' }) }

  context '#update_attribute' do
    it 'calls RDStation to update the email information' do
      expect(rdstation_user).to receive(:update).with(email: current_user.options['new_email'])

      MeSalva::Crm::Rdstation::Users.new(current_user)
                                    .update_attribute('email', current_user.options['new_email'])
    end
    it 'calls RDStation to update some setting information' do
      expect(rdstation_user).to receive(:update).with(setting_attribute: "setting_value_new")

      MeSalva::Crm::Rdstation::Users.new(current_user)
                                    .update_attribute('setting_attribute', "setting_value_new")
    end
  end
end
