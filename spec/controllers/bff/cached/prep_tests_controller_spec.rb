# frozen_string_literal: true

RSpec.describe Bff::Cached::PrepTestsController, type: :controller do
  describe "GET #show_weekly " do
    context "with time freeze" do
      before { Timecop.freeze("2022-06-25 12:00:00 -0300") }
      it "should return current prep test to the week by current time", :vcr do
        get :show_weekly
        expected = { "expiresAt" => "2022-06-27",
                     "permalink" => "enem-e-vestibulares/simulados/simuladinho-9",
                     "startsAt" => "2022-06-20",
                     "text" => "Simuladinho 9 - Provas de Ciências da Natureza e Matemática" }
        expect(parsed_response['results']).to eq(expected)
      end
    end
  end
end
