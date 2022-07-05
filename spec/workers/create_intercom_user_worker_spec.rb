# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'intercom worker' do |workers|
  workers.each do |verb|
    describe "#{verb.classify}IntercomUserWorker".constantize do
      let!(:user) { create(:user) }

      describe '#perform' do
        it "#{verb}s the intercom user" do
          client = double(create: true, update: true, destroy: true)
          allow(MeSalva::Crm::Users).to receive(:new) { client }

          expect(client).to receive(verb.to_sym)
          subject.perform(user.id, user.class.to_s)
        end
      end
    end
  end
end

RSpec.describe CreateIntercomUserWorker do
  describe 'intercom worker' do
    it_should_behave_like 'intercom worker', %w[create update destroy]
  end
end
