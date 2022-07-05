# frozen_string_literal: true

require 'spec_helper'

describe MeSalva::Crm::Rdstation::Authentication do
  before do
    auth = double
    allow(RDStation::Authentication).to receive(:new)
      .with(ENV['RDSTATION_CLIENT_ID'], ENV['RDSTATION_CLIENT_SECRET'])
      .and_return(auth)
    allow(auth).to receive(:update_access_token)
      .with(ENV['RDSTATION_RESET_TOKEN']).and_return(update_access_response)
  end
  let(:subject) { MeSalva::Crm::Rdstation::Authentication.new }
  let(:update_access_response) do
    JSON.parse(File.read(file_path_auth_response))
  end
  let(:file_path_auth_response) do
    'spec/fixtures/rdstation/authentication_response.json'
  end

  describe '#access_token' do
    it 'returns access token of rdstation' do
      expect(subject.access_token).to eq(update_access_response['access_token'])
    end
  end
end
