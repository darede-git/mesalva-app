# frozen_string_literal: true

module EssayEventsParamsHelper
  def essay_event_params(event_name, essay_submission, **metadata)
    @event_name = event_name
    @user = essay_submission.user
    @essay_submission = essay_submission

    essay_params_hash(metadata)
  end

  def intercom_params(**metadata)
    essay_data
      .merge(user_info)
      .merge(correction_info(metadata))
      .merge(grades)
  end

  private

  def essay_data
    { essay_submission_id: @essay_submission.id,
      correction_style: @essay_submission.correction_style.name,
      essay_status: @essay_submission.status,
      permalink: @essay_submission.permalink.slug }
  end

  def correction_info(**metadata)
    { valuer_uid: metadata[:valuer_uid],
      delayed: @essay_submission.delayed? }
  end

  def grades
    { grades: @essay_submission.grades }
  end

  def essay_params_hash(**metadata)
    event_data.merge(intercom_params(metadata))
  end

  def event_data
    { event_name: @event_name,
      created_at: Time.now }
  end

  def user_info
    { user_id: @user.id,
      user_email: @user.try(:email),
      user_uid: @user.try(:uid),
      user_name: @user.try(:name) }
  end
end
