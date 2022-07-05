# frozen_string_literal: true

module PermalinkAuthorization
  extend ActiveSupport::Concern

  private

  def permalink_access
    @permalink_access ||= MeSalva::Permalinks::Access.new
  end

  def accessible_permalink?
    @accessible_permalink ||= begin
      return true if viewable_medium?
      return false unless authorized_role?(%w[user])
      return true if permalink_ends_with_medium? && item_is_free?

      permalink_access.validate(@permalink.node_ids, current_user)
    end
  end

  def authorization_status
    return :ok unless permalink_ends_with_medium?
    return :ok if accessible_permalink?

    :unauthorized
  end

  def item_is_free?
    @permalink.item.free
  end

  def validate_request
    return invalid_request unless valid_params?
    return render_unauthorized unless allowed_request?
  end

  def allowed_request?
    accessible_permalink? || viewable_medium?
  end

  def viewable_medium?
    return false unless view_action?
    return true if @permalink.viewable_to_guests?

    @permalink.ends_with_exercise_medium?
  end

  def invalid_request
    render_unprocessable_entity(t('permalink.invalid_permalink'))
  end

  def read_action?
    event_params[:event_name] == PermalinkEvent::TEXT_READ
  end

  def rate_action?
    event_params[:event_name] == PermalinkEvent::CONTENT_RATE &&
      param?(:rating)
  end

  def download_action?
    event_params[:event_name] == PermalinkEvent::DOWNLOAD
  end

  def answer_action?
    exercise_action? || prep_test_action?
  end

  def exercise_action?
    event_params[:event_name] == PermalinkEvent::EXERCISE_ANSWER &&
      param?(:answer_id)
  end

  def prep_test_action?
    event_params[:event_name] == PermalinkEvent::PREP_TEST_ANSWER
  end

  def view_action?
    params['action'] == 'show'
  end

  def watch_action?
    event_params[:event_name] == PermalinkEvent::LESSON_WATCH
  end

  def param?(param)
    event_params.key?(param)
  end
end
