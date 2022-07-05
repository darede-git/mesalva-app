# frozen_string_literal: true

require 'me_salva/crm/client'
require 'spec_helper'

describe MeSalva::Crm do
  describe '#new' do
    let(:test_instance) { TestClass.new }

    before { setup }

    it 'instantiate a new Intercom client' do
      allow(Intercom::Client).to receive(:new).and_return(Intercom::Client)

      expect(test_instance.client).to eq(Intercom::Client)
    end
  end

  def setup
    stub_const('Intercom::Client', double)
  end
end

class TestClass
  include MeSalva::Crm
end
