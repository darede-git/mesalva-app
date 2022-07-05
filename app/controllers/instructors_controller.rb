# frozen_string_literal: true

class InstructorsController < ApplicationController
  before_action -> { authenticate(%w[user]) }
  before_action :set_instructor, except: :create
  before_action :student_under_instructor?,
                only: %i[student
                         student_exercises
                         student_watched_and_read_material]

  def create
    return unless ENV['MESALVA_FOR_SCHOOLS_TEST_CAMPAIGN_ACTIVE'] == "true"
    return already_instructor_error if current_user_instructor

    Instructor.create(create_params)
    Access.create(user_id: current_user.id,
                  package_id: ENV['MESALVA_FOR_SCHOOLS_PACKAGE_ID'].to_i,
                  starts_at: Time.now,
                  expires_at: end_interval,
                  gift: true)
    head :created
  end

  # rubocop:disable Naming/PredicateName
  def is_instructor
    render json: serialize(@instructor), status: :ok
  end
  # rubocop:enable Naming/PredicateName

  def student
    student = ActiveRecord::Base.connection.execute(
      query_student_activity(params['student_uid'])
    )
    render json: student, status: :ok
  end

  def students
    render json: @instructor.users, status: :ok
  end

  def student_watched_and_read_material
    student = ActiveRecord::Base.connection.execute(
      query_student_watched_and_read_material(params['student_uid'])
    )
    render json: student, status: :ok
  end

  def student_exercises
    student = ActiveRecord::Base.connection.execute(
      query_student_exercises(params['student_uid'])
    )
    render json: student, status: :ok
  end

  private

  def student_under_instructor?
    return render_not_found unless
      @instructor.users.pluck(:uid).include?(params['student_uid'])
  end

  def query_student_activity(student_uid)
    <<~SQL
      SELECT permalink_events.permalink_item_type AS "type", count(permalink_events.id)
      FROM permalink_events
      INNER JOIN users ON users.id = permalink_events.user_id
      WHERE permalink_events.id > 88000000
      AND users.uid = '#{student_uid}'
      GROUP BY "type"
    SQL
  end

  def query_student_watched_and_read_material(student_uid)
    <<~SQL
      SELECT items.name, permalink_events.event_name, permalink_events.created_at as "consumed_at"
      FROM permalink_events
      INNER JOIN users ON users.id = permalink_events.user_id
      INNER JOIN items ON items.id = permalink_events.permalink_item_id
      WHERE permalink_events.id > 88000000
      AND users.uid = '#{student_uid}'
      AND permalink_events.event_name > 'lesson_watch'
      OR permalink_events.event_name > 'text_read'
    SQL
  end

  def query_student_exercises(student_uid)
    <<~SQL
      WITH base AS
      (SELECT permalink_node_module_id,
              (array_agg(permalink_answer_correct)) [ 1 ]::int permalink_answer_correct,
              (array_agg(permalink_events.created_at)) [ 1 ]   created_at_event
       FROM permalink_events
       INNER JOIN users ON permalink_events.user_id = users.id
       WHERE permalink_events.id > 88000000
       AND permalink_node_slug [ 1 ] = 'enem-e-vestibulares'
       AND permalink_medium_type = 'fixation_exercise'
       AND users.uid = '#{student_uid}'
       GROUP BY permalink_node_module_id
       ORDER BY created_at_event)

      SELECT node_modules.name,
             SUM(permalink_answer_correct) AS correct_answers,
             COUNT(permalink_answer_correct) AS answers_count,
             base.created_at_event
      FROM base
      INNER JOIN node_modules ON base.permalink_node_module_id = node_modules.id
      GROUP BY node_modules.name, base.created_at_event
      ORDER BY base.created_at_event
    SQL
  end

  def set_instructor
    @instructor = current_user_instructor

    return render_not_found unless @instructor
  end

  def current_user_instructor
    Instructor.find_by_user_id(current_user.id)
  end

  def already_instructor_error
    render json: { errors: [t('errors.messages.already_instructor')] },
           status: :unprocessable_entity
  end

  def instructor_params
    params.permit(:infos)
  end

  def create_params
    instructor_params.merge(
      user_id: current_user.id,
      package_id: ENV['MESALVA_FOR_SCHOOLS_PACKAGE_ID'].to_i
    )
  end

  def end_interval
    Time.now + ENV['MESALVA_FOR_SCHOOLS_PACKAGE_INTERVAL_IN_DAYS'].to_i.days
  end
end
