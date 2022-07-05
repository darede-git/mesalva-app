# frozen_string_literal: true

require 'me_salva/event/permalink/prep_tests'
require 'me_salva/event/permalink/prep_test_answers'

class PrepTestEventsController < ApplicationController
  include SerializationHelper
  include CrmEventsParamsHelper
  include PermalinkEventHelper
  include PermalinkAuthorization
  include RdStationHelper

  before_action -> { authenticate(%w[user]) }, only: %i[index create show]
  before_action :validate_anwers_permalinks, only: :create

  def index
    render json: prep_tests,
           serializer: Event::PrepTestsSerializer,
           adapter: :attributes
  end

  def show
    response = prep_test_answers
    return render_not_found if response.results.empty?

    render json: response,
           serializer: Event::PrepTestAnswersSerializer,
           adapter: :attributes
  end

  def create
    create_event_prep_test_answer
    tri_score if @permalink.item.tri_reference
    @prep_test_cache.save(@meta, current_user.uid)
    render json: @permalink, serializer: Permalink::PermalinkSerializer,
           meta: @meta, status: :created
  end

  private

  def tri_score
    tri_api = MeSalva::Tri::ScoreApi.new(
      @meta[:answers], @permalink.item
    )
    @meta[:score] = tri_api.tri_score
    save_tri_score
  end

  def save_tri_score
    PrepTestScore.new(
      user: current_user,
      submission_token: submission_token,
      score: @meta[:score],
      permalink_slug: @permalink.slug
    ).save!
  end

  def validate_anwers_permalinks
    @permalinks = answers_permalinks
    return invalid_request unless valid_permalinks?
  end

  def create_event_prep_test_answer
    @prep_test_cache = MeSalva::PrepTest::PrepTestCache.new(submission_token)
    @permalinks.each_with_index do |permalink, index|
      @permalink = permalink
      @answer = params[:answers][index]
      @prep_test_cache.add(@permalink, correct_answer?)
      append_prep_test_event(PermalinkEvent::PREP_TEST_ANSWER, correct_answer?)
      populate_meta
    end
    create_appended_prep_test_events
    send_rd_station_event(event: :prep_test_answer,
                          params: { user: current_user, submission_token: submission_token,
                                    item: @permalink.item, node_module: @permalink.node_module })
  end

  def valid_permalinks?
    @permalinks.all?(&:present?)
  end

  def answers_permalinks
    permalinks_by_slug = {}
    Permalink.by_slug(answers_slugs).each do |permalink|
      permalinks_by_slug[permalink.slug] = permalink
    end
    answers_slugs.map { | slug | permalinks_by_slug[slug] }
  end

  def answers_slugs
    params[:answers].map { |answer| answer['slug'] }
  end

  def populate_meta
    @meta ||= { answers: [] }
    @meta[:answers] << { 'slug' => @permalink.medium.slug,
                         'correct' => correct_answer?,
                         'correction' => @permalink.medium.correction,
                         'submission-token' => submission_token,
                         'medium-text' => @permalink.medium.medium_text,
                         'answer-correct' => medium_correct_answer_id }
  end

  def medium_correct_answer_id
    @permalink.medium.correct_answer_id
  end

  def event_params
    { slug: @answer[:slug],
      answer_id: @answer[:answer_id],
      event_name: @answer[:event_name],
      submission_at: submission_at,
      submission_token: submission_token,
      starts_at: @answer[:starts_at] }
  end

  def user_by_token
    @user_by_token ||= set_user_by_token(:user)
  end

  def submission_at
    @submission_at ||= Time.now.strftime(t('time.formats.date'))
  end

  def answer_attr(answer)
    @answer = answer
  end

  def submission_token
    @submission_token ||= encrypt_submission_at
  end

  def encrypt_submission_at
    Base64.encode64(submission_at).delete("\n").delete("=")
  end

  def prep_tests
    MeSalva::Event::Permalink::PrepTests.new(current_user, params[:node_module_slug], params[:full] == 'true')
  end

  def prep_test_answers
    MeSalva::Event::Permalink::PrepTestAnswers.new(
      user_id: current_user.id,
      submission_token: params[:submission_token],
      full: params[:full] == 'true'
    )
  end
end
