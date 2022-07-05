# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContentTeacher, type: :model do
  describe 'Validations' do
    context 'with the content_teacher valid' do
      let!(:content_teacher) { create(:content_teacher) }
      it 'should be valid' do
        expect(content_teacher).to be_valid
      end
    end
  end
end
