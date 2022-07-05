# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PrepTestDetailWorker do
  context 'perform' do
    it 'creates PrepTestDetail' do
      expect do
        subject.perform(token: 'token', weight: '1', suggestion_type: 'suggestion_type')
      end.to change(PrepTestDetail, :count).by(1)
    end
  end
end
