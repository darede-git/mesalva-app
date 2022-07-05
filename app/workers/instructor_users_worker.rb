# frozen_string_literal: true

class InstructorUsersWorker
  include Sidekiq::Worker

  def perform
    return unless ENV['INSTRUCTOR_USERS_WORKER_ENABLED'] == 'true'

    new_students_by_instructor.each do |row|
      instructor = Instructor.find_by_user_id(row['user_id'])

      create_students_for_instructor(row['new_students'], instructor)
    end
  end

  private

  def new_students_by_instructor
    ActiveRecord::Base.connection.execute(new_students_query)
  end

  def create_students_for_instructor(new_students, instructor)
    make_array_of_students(new_students).each do |new_student|
      next if new_student == instructor.user.id

      create_access_and_add_to_instructor(new_student, instructor)
    end
  end

  def last_checked_for_students
    time = ActiveRecord::Base.connection.execute(
      <<~SQL
        UPDATE instructor_last_checked_for_students
        SET time = '#{Time.now}'
        FROM instructor_last_checked_for_students old_value
        RETURNING old_value.time
      SQL
    ).first
    return Time.now - 5.minutes if time.nil?

    Time.parse(time['time'])
  end

  def new_students_query
    <<~SQL
      WITH tokens AS (
        SELECT DISTINCT
          users.token AS token,
          users.id as user_id
        FROM users
        INNER JOIN instructors ON instructors.user_id = users.id
      )
      SELECT tokens.user_id,
            tokens.token,
            array_agg(crm_events.user_id) as new_students
      FROM utms
      INNER JOIN crm_events ON crm_events.id = utms.referenceable_id
      INNER JOIN tokens ON tokens.token = utms.utm_content
      WHERE utms.utm_source = 'quarentena-covid19'
      AND utms.utm_medium = 'link_pessoal'
      AND utms.utm_campaign = 'covid19'
      AND utms.referenceable_type = 'CrmEvent'
      AND utms.id > 13600000
      AND crm_events.id > 8800000
      AND crm_events.event_name = 'campaign_sign_up'
      AND crm_events.created_at > '#{last_checked_for_students}'
      GROUP BY tokens.user_id, tokens.token
    SQL
  end

  def create_access(user, package_id)
    return if user.accesses.pluck(:package_id).include?(package_id)

    package = Package.find package_id

    user.accesses << Access.new(
      user_id: user.id,
      package_id: package.id,
      starts_at: Time.now,
      expires_at: end_interval(package),
      active: true,
      gift: true
    )
  end

  def add_student_to_instructor(user, instructor)
    return if instructor.users.include?(user)

    instructor.users << user
  end

  def make_array_of_students(new_students_from_query)
    new_students_from_query.gsub(/{|}/, '').split(',')
  end

  def end_interval(package)
    Time.now + package.duration.months
  end

  def create_access_and_add_to_instructor(new_student, instructor)
    user = User.find(new_student)
    unless user_already_has_access(user, instructor.package_id)
      create_access(user, instructor.package_id)
    end

    add_student_to_instructor(user, instructor)
  end

  def user_already_has_access(user, package_id)
    user.accesses
        .active
        .pluck(:package_id)
        .include?(package_id)
  end
end
