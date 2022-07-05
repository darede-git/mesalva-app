# frozen_string_literal: true

require 'rails_helper'

describe TokenHelper do
  describe '#generate_token' do
    context 'without params' do
      it 'generates a token' do
        order = FactoryBot.build(:order)
        allow(order).to receive_messages(token_already_exists?: false)
        order.generate_token

        expect(order.token).not_to be_nil
      end
    end

    context 'with overwrite true' do
      it 'generates a new token' do
        order = FactoryBot.build(:order, token: '123')
        allow(order).to receive_messages(token_already_exists?: false)
        order.generate_token(overwrite: true)

        expect(order.token).not_to eq('123')
      end
    end

    context 'converters' do
      it 'generates a custom token ' do
        order = FactoryBot.build(:order)
        allow(order).to receive_messages(token_already_exists?: false)
        order.generate_token(converters: ->(x) { x[0..9] })

        expect(order.token.length).to eq(10)
      end
    end
  end
end
