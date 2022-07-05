# frozen_string_literal: true

class EssaySubmissionsController < ApplicationController
  include EssaySubmissionConcern
  include IntercomHelper
  include EssayEventsParamsHelper
  include QueryHelper

  before_action -> { authenticate_permalink_access(%w[user]) }, only: %i[create verify]
  before_action -> { authenticate_permalink_access(%w[admin teacher user]) }, except: %i[create verify]
  before_action :set_essay_submission, only: %i[show update]
  before_action :valid_user_access?, only: :create
  before_action :set_platform, only: :index
  before_action :user_has_enough_credits?, only: :create
  before_action :validate_update, only: :update

  def index
    return render_invalid_order_by unless valid_order_by_param?

    @essay_submissions = essay_submissions.page(page_param).per_page(per_page_param)
    render json: @essay_submissions,
           include: %i[correction_style user],
           status: :ok
  end

  def show
    if @essay_submission && valid_resource?
      render json: serialize(@essay_submission,
                                serializer: 'EssaySubmission',
                                include: %i[correction_style
                                            user essay_marks
                                            essay_correction_checks
                                            essay_submission_grades]),
             status: :ok
    else
      render_unauthorized('permalink.unauthorized')
    end
  end

  def verify
    if current_pending_essay == max_pending_essay
      return render_unauthorized('errors.messages.pending_essay_limit')
    end

    render json: pending_sended_themes.as_json, status: :ok
  end

  def create
    @essay_submission = EssaySubmission.new(create_essay_params)
    @essay_submission.platform = @platform unless @platform.nil?

    if @essay_submission.save
      @essay_submission.create_empty_grades
      create_essay_event
      render json: serialize(@essay_submission.reload, serializer: 'EssaySubmission'),
             status: :created
    else
      render_unprocessable_entity(@essay_submission.errors)
    end
  end

  def update
    if @essay_submission&.update(update_submission_params)
      update_status
      render json: serialize(@essay_submission,
                                serializer: 'EssaySubmission',
                                include: %i[correction_style user essay_marks
                                            essay_correction_checks essay_submission_grade]),
             status: :ok
    else
      render_unprocessable_entity(@essay_submission.errors)
    end
  end

  private

  def current_pending_essay
    current_user.essay_submissions.where(status: 1).count
  end

  def free_or_unlimited_credits?
    return true unless @permalink
    return true if @permalink.free_item?
    return true if user_with_unlimited_credits?
  end

  def user_with_unlimited_credits?
    current_user.accesses
                .map(&:package)
                .pluck(:unlimited_essay_credits)
                .include?(true)
  end

  def user_has_enough_credits?
    return true if free_or_unlimited_credits?

    return render_unauthorized unless current_user.accesses
                                                  .pluck(:essay_credits)
                                                  .inject('+')
                                                  .positive?
  end

  def create_essay_event
    EssayEvent.create!(essay_event_params('essay_submission',
                                          @essay_submission))

    create_intercom_event('essay_submission', current_user, intercom_params)
    create_lesson_event
  end

  def create_lesson_event
    return if permalink.nil?

    LessonEvent.create!(user: current_user, item_slug: permalink.item.slug,
                        node_module_slug: permalink.node_module.slug,
                        submission_token: @essay_submission.token)
  end

  def correction_style
    @essay_submission.correction_style
  end

  def essay_submissions
    EssaySubmission
      .select_filtered(filter_params)
      .order_by_deadline_at(order_direction)
  end

  def admin_not_filter
    return {} unless admin_signed_in?

    { "status": 0, active: false }
  end

  def filter_params
    params.permit(:correction_style_id, :updated_by_uid,
                  :correction_type, :item_name, :deadline_at,
                  :node_module_slug, package_id: params['package_id'],
                                     admin_signed_in: admin_signed_in?)
          .merge(user_filter)
          .merge(status_filter)
          .merge(permalink_filter)
          .merge(platform_filters)
  end

  def platform_filters
    {
      platform_id: @platform&.id,
      platform_unity_id: platform_unity_id,
      platform_unity_slug: params['platform_unity'],
      platform_slug: params['platform_slug']
    }
  end

  def platform_unity_id
    PlatformUnity.find_by_slug(params['platform_unity'])&.id
  end

  def user_filter
    return { user: current_user } if user_signed_in? && !admin_signed_in?
    return { user: user_by_uid } if params[:uid]

    {}
  end

  def permalink_filter
    return { permalink: permalink } if params[:permalink_slug]

    {}
  end

  def status_filter
    return { status: essay_status_dehumanize } if params[:status]

    {}
  end

  def user_by_uid
    User.find_by_uid(params[:uid])
  end

  def essay_status_dehumanize
    EssaySubmission.convert_status_key(params[:status].to_sym)
  end

  def valid_order_by_param?
    %w[asc desc].include?(order_direction)
  end

  def order_direction
    params['order_by'] || 'desc'
  end

  def render_invalid_order_by
    render_unprocessable_entity(t('errors.messages.invalid_order_param'))
  end

  def admin_request?
    admin_signed_in?
  end

  def set_essay_submission
    @essay_submission = EssaySubmission.find_by_token(params[:id])
    render_not_found unless @essay_submission
  end

  def create_essay_params
    return false unless @permalink&.essay_medium?

    params.permit(:correction_style_id, :essay, :correction_type, draft: {})
          .merge(user: current_user, permalink: @permalink)
  end

  def update_submission_params
    return update_user_params if user_signed_in? && !admin_signed_in?

    params.permit(:corrected_essay, :uncorrectable_message, :feedback,
                  :draft_feedback,
                  grades: %i[grade_1 grade_2 grade_3 grade_4 grade_5
                             grade_6 grade_7 grade_8 grade_9 grade_10],
                  appearance: {},
                  essay_marks_attributes: essay_marks_attributes,
                  essay_submission_grades_attributes: essay_submission_grades_attributes,
                  essay_correction_checks_attributes: essay_correction_checks_attributes)
          .merge(updated_by_uid: current_valuer&.uid)
  end

  def update_user_params
    params.permit(:rating, :essay, draft: {})
  end

  def essay_submission_grades_attributes
    %i[id grade correction_style_criteria_id essay_submission_id _destroy]
  end

  def essay_marks_attributes
    [:id, :description, :_destroy, :mark_type, { coordinate: {} }]
  end

  def essay_correction_checks_attributes
    [:id, :_destroy, :correction_style_criteria_check_id, { checked: [] }]
  end

  def set_platform
    return nil unless params[:platform_slug].present?

    @platform = Platform.find_by_slug(params[:platform_slug])
  end
end
