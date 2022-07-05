# frozen_string_literal: true

require 'spec_helper'

describe MeSalva::Crm::Rdstation::Event::Client do
  let(:subject) do
    MeSalva::Crm::Rdstation::Event::Client.new({ user: user,
                                                 event_name: event_name,
                                                 payload: payload })
  end
  let(:event_name) { 'event_name' }
  let(:payload) { { cf_1: 'custom field 1', cf_2: 'custom field 2' } }
  let(:body) do
    { event_type: 'CONVERSION',
      event_family: 'CDP',
      payload: {
        conversion_identifier: event_name, name: user.name,
        email: user.email, mobile_phone: user.phone
      }.merge(payload) }
  end
  let(:event_response) do
    JSON.parse(File.read('spec/fixtures/rdstation/event_response.json'))
  end

  describe '#create' do
    context 'valid user' do
      let(:event) { double }
      let(:access_token) { 'access_token' }

      before do
        auth = double
        expect(MeSalva::Crm::Rdstation::Authentication).to receive(:new)
          .and_return(auth)
        expect(auth).to receive(:access_token).and_return(access_token)
        expect(RDStation::Events).to receive(:new).with(access_token)
                                                  .and_return(event)
        expect(event).to receive(:create).with(body).and_return(event_response)
      end

      it 'create rdstation event' do
        subject.create
      end
    end

    context 'invalid user' do
      before do
        user.update(email: nil, crm_email: nil, provider: 'facebook')
        expect(MeSalva::Crm::Rdstation::Authentication).not_to receive(:new)
        expect(RDStation::Events).not_to receive(:new)
      end

      it 'not create event' do
        subject.create
      end
    end
  end
end
