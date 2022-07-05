# frozen_string_literal: true

module EssaySubmissionConcern
  include PermalinkAuthorization
  include UserAccessHelper

  def valid_user_access?
    return unless find_permalink
    return true if @permalink.free_item?
    return true if permalink_access.validate(@permalink.node_ids, current_user)

    render_unauthorized
  end

  def pending_sended_themes
    current_user.essay_submissions
                .where(status: 1)
                .map(&:permalink)
                .map(&:item).uniq
  end

  def max_pending_essay
    current_user.accesses
                .map(&:package)
                .pluck(:max_pending_essay)
                .map(&:to_i).max
  end

  def valid_resource?
    return true if admin_signed_in? || teacher_signed_in?

    return true if @essay_submission.user == current_user

    MeSalva::Platforms::PlatformRolesPermission.new(current_user)
                                               .manager_of_student?(@essay_submission.user)
  end

  def validate_status
    return if essay_status.nil?
    return render_unauthorized if invalid_user_transition?

    render_change_not_permitted unless can_transition_to_essay_status?
  end

  def validate_update
    return render_unauthorized unless valid_resource?

    validate_status
  end

  def update_status
    return if essay_status.nil?
    return unless @essay_submission.state_machine.can_transition_to?(essay_status.to_sym)

    @essay_submission.state_machine.transition_to(
      essay_status.to_sym,
      valuer: current_valuer
    )
  end

  def find_permalink
    @permalink if permalink&.essay_medium?
  end

  def permalink
    @permalink ||= Permalink.find_by_slug(params[:permalink_slug])
  end

  def current_valuer
    current_admin || current_teacher
  end

  def can_transition_to_essay_status?
    @essay_submission.state_machine.can_transition_to?(essay_status.to_sym)
  end

  def invalid_user_transition?
    (user_signed_in? && !admin_signed_in?) && essay_status != 'cancelled'
  end

  def invalid_status
    render_unprocessable_entity(
      t('errors.messages.state_machine.invalid_status')
    )
  end

  def render_change_not_permitted
    render_precondition_failed(t('errors.messages.essay_status'))
  end

  def essay_status
    params[:status]
  end
end
