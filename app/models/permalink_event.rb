# frozen_string_literal: true

class PermalinkEvent < ActiveRecord::Base
  LESSON_WATCH = 'lesson_watch'
  EXERCISE_ANSWER = 'exercise_answer'
  CONTENT_RATE = 'content_rate'
  TEXT_READ = 'text_read'
  PREP_TEST_ANSWER = 'prep_test_answer'
  DOWNLOAD = 'download'
  PUBLIC_DOCUMENT_READ = 'public_document_read'
  SOUNDCLOUD_LISTEN = 'soundcloud_listen'
  TYPEFORM_ANSWER = 'typeform_answer'

  ALLOWED_EVENT_NAMES = [LESSON_WATCH, EXERCISE_ANSWER, CONTENT_RATE,
                         TEXT_READ, PREP_TEST_ANSWER, DOWNLOAD,
                         PUBLIC_DOCUMENT_READ, SOUNDCLOUD_LISTEN,
                         TYPEFORM_ANSWER].freeze

  VIDEO_EVENT_NAMES = [LESSON_WATCH, CONTENT_RATE, DOWNLOAD].freeze

  INTERCOM_EVENTS = [LESSON_WATCH, EXERCISE_ANSWER, CONTENT_RATE,
                     TEXT_READ, DOWNLOAD].freeze

  validates :permalink_slug, :permalink_node, :permalink_node_id,
            :permalink_node_module_id, :permalink_item_id, :permalink_medium_id,
            :event_name, presence: true, allow_blank: false

  validates :event_name, inclusion: { in: ALLOWED_EVENT_NAMES }

  with_options if: :answer_event? do
    validates :permalink_answer_correct, inclusion: { in: [true, false] }
    validates :permalink_medium_type,
              inclusion: { in: %w[fixation_exercise comprehension_exercise] }
  end

  validates :permalink_medium_type,
            inclusion: { in: %w[video
                                streaming
                                essay_video
                                correction_video] },
            if: :watch_event?

  validates :permalink_medium_type,
            inclusion: { in: %w[text
                                essay
                                public_document
                                soundcloud
                                typeform
                                pdf] },
            if: :text_read_event?

  def self.raw_field
    { raw: { type: 'text', index: true } }
  end

  private

  def answer_event?
    [EXERCISE_ANSWER, PREP_TEST_ANSWER].include?(event_name)
  end

  def watch_event?
    event_name == LESSON_WATCH
  end

  def text_read_event?
    event_name == TEXT_READ
  end
end
