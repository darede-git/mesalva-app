# frozen_string_literal: true

class EssaySubmissionMailer < ApplicationMailer
  def delivered_essay(essay, platform_slug = nil)
    @name = essay.user.name
    @token = essay.token
    set_platform(platform_slug)
    send_email(essay.user.email, delivered_subject)
  end

  def re_corrected(essay, platform_slug = nil)
    @name = essay.user.name
    @token = essay.token
    set_platform(platform_slug)
    send_email(essay.user.email, re_corrected_subject)
  end

  def uncorrectable_essay(essay, platform_slug = nil)
    @name = essay.user.name
    @essay_name = essay_submission_name(essay.token)
    
    @uncorrectable_title = essay.uncorrectable_message.sub(/:.*/, "")
    @uncorrectable_text = essay.uncorrectable_message.sub(/^.*?:/, "")

    set_platform(platform_slug)
    send_email(essay.user.email, uncorrectable_subject)
  end

  private

  def send_email(email, subject)
    return if email.nil?

    mail(to: email, subject: subject, from: sender)
  end

  def uncorrectable_subject
    I18n.t('mailer.essay_submission.uncorrectable.subject',
           platform: @platform.try(:name) || 'Me Salva!')
  end

  def delivered_subject
    I18n.t('mailer.essay_submission.delivered.subject')
  end

  def re_corrected_subject
    I18n.t('mailer.essay_submission.re_corrected.subject')
  end

  def essay_submission_name(token)
    @essay_submission = EssaySubmission.find_by_token(token)
    @essay_submission ? @essay_submission.permalink&.item&.name : nil
  end
end
