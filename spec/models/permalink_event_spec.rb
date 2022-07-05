# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PermalinkEvent, type: :model do
  context 'validations' do
    should_be_present(:permalink_slug, :permalink_node, :permalink_node_id,
                      :permalink_node_module_id, :permalink_item_id,
                      :permalink_medium_id, :event_name)

    it do
      should validate_inclusion_of(:event_name)
        .in_array(%w[lesson_watch exercise_answer content_rate text_read
                     prep_test_answer download])
    end

    context 'event name is answer' do
      before { subject.event_name = 'exercise_answer' }

      it do
        should validate_inclusion_of(:permalink_medium_type)
          .in_array(%w[fixation_exercise comprehension_exercise])
      end
    end

    context 'event name is lesson watch' do
      before { subject.event_name = 'lesson_watch' }

      it do
        should validate_inclusion_of(:permalink_medium_type)
          .in_array(%w[video streaming essay_video correction_video])
      end
    end

    context 'event name is text read' do
      before { subject.event_name = 'text_read' }

      it do
        should validate_inclusion_of(:permalink_medium_type)
          .in_array(%w[text essay public_document pdf])
      end
    end
  end

  let(:permalink_with_utm) do
    FactoryBot.attributes_for(:permalink_event,
                              :with_request_headers,
                              :with_utm_attributes)
  end

  let(:permalink_with_utm_blank) do
    FactoryBot.attributes_for(:permalink_event,
                              :with_request_headers,
                              :with_utm_attributes_blank)
  end
end
