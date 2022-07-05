# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/event/permalink/prep_tests'

describe MeSalva::Event::Permalink::PrepTests do
  describe 'query building' do
    context 'prep_tests query' do
      let!(:item) { create(:item) }
      let!(:user) { create(:user) }
      let!(:lesson_event) { create(:lesson_event, user: user, item_slug: item.slug) }
      let!(:lesson_event_2) do
        create(:lesson_event, user: user, item_slug: item.slug,
                              submission_token: 'token2')
      end

      it 'returns prep_tests grouped by item' do
        results = MeSalva::Event::Permalink::PrepTests
                  .new(user, lesson_event.node_module_slug)
                  .results

        expect(results.pluck(:submission_token).sort).to eq(%w[token token2])
      end
    end
  end
end
