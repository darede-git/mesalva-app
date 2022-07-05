# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PrepTestOverviewWorker do
  context 'perform' do
    it 'creates PrepTestOverview' do
      expect do
        subject.perform(token: 'token', permalink_slug: 'permalink_slug')
      end.to change(PrepTestOverview, :count).by(1)
    end
  end
end
