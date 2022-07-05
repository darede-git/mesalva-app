# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CourseStructureSummary, type: :model do
  context 'validations' do
    before { create(:course_structure_summary) }
    it { should validate_presence_of(:active) }

    it 'allows only unique slugs' do
      expect { create(:course_structure_summary) }
        .to raise_error(ActiveRecord::RecordInvalid)
      expect do
        create(:course_structure_summary, :different_slug)
      end.not_to raise_error
    end
  end
end
