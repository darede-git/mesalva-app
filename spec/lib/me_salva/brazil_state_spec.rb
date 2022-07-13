# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MeSalva::BrazilState do
  let!(:brazil_state) { MeSalva::BrazilState }
  describe 'ufs' do
    context 'with the valid ufs available' do
      let!(:ufs) { %w[AC AL AP AM BA CE DF GO ES MA MT MS MG PA PB PR PE PI RJ RN RS RO RR SP SC SE TO] }
      context 'for the valid ufs mapping' do
        it 'includes ufs' do
          expect(brazil_state::UFS).to eq(ufs)
        end
      end
    end
  end
end
