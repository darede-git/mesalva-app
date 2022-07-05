# frozen_string_literal: true

require 'me_salva/schedules/client'
require 'rails_helper'

RSpec.describe MeSalva::Schedules::Client do
  include SimplybookAssertionHelper
  context '#next_bookings' do
    context 'with a valid fake token' do
      let(:token) { { 'token' => 'token_test' } }

      context 'and valid fake simplybook data' do
        before { connect_simplybook }

        it 'synchronizes the simplybook data with our database' do
          expect { described_class.new }.not_to raise_error
        end
      end
    end
  end
end
