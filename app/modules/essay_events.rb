# frozen_string_literal: true

module EssayEvents
  extend ActiveSupport::Concern
  include EssayEventsParamsHelper

  def create_essay_event(event_name, model, transition)
    EssayEvent.create!(
      essay_event_params(event_name, model,
                         valuer_uid: valuer_uid(transition))
    )
  end

  def valuer_uid(transition)
    transition.metadata['valuer']['uid'] if transition
                                            .metadata['valuer'].present?
  end
end
