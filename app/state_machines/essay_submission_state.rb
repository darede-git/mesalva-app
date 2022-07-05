# frozen_string_literal: true

class EssaySubmissionState
  include Statesman::Machine
  extend EssayEvents

  state :pending, initial: true
  state :awaiting_correction
  state :correcting
  state :corrected
  state :delivered
  state :cancelled
  state :uncorrectable
  state :re_correcting
  state :re_corrected

  transition from: :pending, to: %i[awaiting_correction cancelled]
  transition from: :awaiting_correction, to: %i[correcting cancelled]
  transition from: :correcting, to: %i[awaiting_correction
                                       corrected
                                       uncorrectable]
  transition from: :corrected, to: %i[awaiting_correction
                                      correcting
                                      delivered]
  transition from: :re_correcting, to: :re_corrected
  transition from: :delivered, to: :awaiting_correction
  transition from: :delivered, to: :re_correcting
  transition from: :uncorrectable, to: :awaiting_correction
  transition from: :cancelled, to: :awaiting_correction

  before_transition do |model|
    @platform_slug = model.platform.try(:slug)
  end

  after_transition(from: :correcting,
                   to: :awaiting_correction) do |model, transition|
    create_essay_event('essay_give_up', model, transition)
  end

  after_transition(from: :corrected,
                   to: :awaiting_correction) do |model, transition|
    create_essay_event('essay_rejected', model, transition)
  end

  after_transition(from: :delivered,
                   to: :awaiting_correction) do |model, transition|
    create_essay_event('essay_reset', model, transition)
  end

  after_transition(from: :cancelled,
                   to: :awaiting_correction) do |model, transition|
    create_essay_event('essay_reset', model, transition)
  end

  after_transition(from: :uncorrectable,
                   to: :awaiting_correction) do |model, transition|
    create_essay_event('essay_reset', model, transition)
  end

  after_transition do |model, transition|
    model.save_status_with_string(transition.to_state)
    unless transition.to_state == 'awaiting_correction'
      create_essay_event("essay_#{transition.to_state}", model, transition)
    end
  end

  after_transition(to: :awaiting_correction) do |model|
    model.reset_attributes
    model.update_send_date
    model.update_deadline
  end

  after_transition(to: :delivered) do |model|
    EssaySubmissionMailer.delivered_essay(model, @platform_slug).deliver_now
  end

  after_transition(from: :re_correcting, to: :re_corrected) do |model|
    EssaySubmissionMailer.re_corrected(model, @platform_slug).deliver_now
  end

  after_transition(to: :uncorrectable) do |model|
    EssaySubmissionMailer.uncorrectable_essay(model, @platform_slug).deliver_now
  end

  after_transition(to: %i[cancelled uncorrectable]) do |model|
    first_expiring_access = Access.user_active_accesses_order_by_expiring_date(model.user)
                                  .first

    first_expiring_access ||= Access.user_accesses_order_by_expiring_date(model.user).first

    first_expiring_access.update(
      essay_credits: first_expiring_access.essay_credits + 1
    )
  end
end
