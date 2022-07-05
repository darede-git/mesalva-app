# frozen_string_literal: true

RSpec.describe Bff::Cached::EssaysController, type: :controller do
  describe 'GET #weekly_essay' do
    context 'for a json' do
      context 'get essays for weekly' do
        before { Timecop.freeze("2022-06-02 12:00:00 -0300") }
        it 'weekly_essay', :vcr do
          get :weekly_essay

          # rubocop: disable Layout/LineLength
          permalink = "enem-e-vestibulares/redacao/redp-propostas-de-redacao/a-disseminacao-do-conhecimento-cientifico-no-mundo-contemporaneo-educacao"
          # rubocop: enable Layout/LineLength

          expected = {
            "expiresAt" => "2022-06-06",
            "permalink" => permalink,
            "startsAt" => "2022-05-30",
            "text" => "A disseminação do conhecimento científico no mundo contemporâneo"
          }
          expect(parsed_response['results']['essay']).to eq(expected)
        end
      end
    end
  end
end
