# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/event/user/last_modules_cache'

RSpec.describe UpdateUserLastModulesCacheWorker do
  describe '#perform' do
    it 'updates user last modules key in redis' do
      expect_any_instance_of(MeSalva::Event::User::LastModulesCache)
        .to receive(:update)
      subject.perform(2, 'permalink')
    end
  end
end
