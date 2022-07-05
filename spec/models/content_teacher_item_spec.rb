# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContentTeacherItem, type: :model do
  describe 'Validations' do
    context 'with the content_teacher_item valid' do
      let!(:content_teacher) { create(:content_teacher) }
      let!(:item) { create(:item) }
      let!(:content_teacher_item) do
        create(:content_teacher_item, content_teacher_id: content_teacher.id, item_id: item.id)
      end
      it 'should be valid' do
        expect(content_teacher_item).to be_valid
        expect(content_teacher_item.item_id).to eq(item.id)
        expect(content_teacher_item.content_teacher_id).to eq(content_teacher.id)
      end
    end
  end
end
