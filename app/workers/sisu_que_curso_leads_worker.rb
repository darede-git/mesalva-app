# frozen_string_literal: true

class SisuQueCursoLeadsWorker
  include Sidekiq::Worker
  include QueryHelper

  def perform
    return unless ENV['SISU_QUECURSO_LEADS_WORKER_ACTIVE'] == "true"

    write_leads
  end

  private

  def write_leads
    options = {
      bucket: "mesalva-internal",
      file_path: "leads-quecurso/",
      public: false
    }

    MeSalva::Aws::File.write("Leads-#{Date.today}.csv",
                             leads_csv_string,
                             options)
  end

  def leads_csv_string
    CSV.generate do |csv|
      csv << %w[name email city state phone
                birth_date origin courses_states_queried]
      leads.each do |lead|
        csv << [lead['name'],
                lead['email'],
                lead['city'],
                lead['state'],
                lead['phone'],
                lead['birth_date'],
                lead['origin'],
                lead['answer']]
      end
    end
  end

  def leads
    ActiveRecord::Base.connection.execute(query)
  end

  def query
    sanitized_dates = snt_sql(
      [":start_date and :end_date",
       { start_date: worker_start_date,
         end_date: worker_end_date }]
    )
    <<~SQL
      WITH
        q_submission AS (
          SELECT q_submission.id, q_submission.user_id, q_submission.created_at
          FROM quiz_form_submissions q_submission
          WHERE q_submission.created_at BETWEEN #{sanitized_dates}
        ),
        q_courses AS (
          SELECT q_submission.id, q_alt.description course
          FROM q_submission
          INNER JOIN quiz_answers q_ans ON q_submission.id = q_ans.quiz_form_submission_id
          INNER JOIN quiz_alternatives q_alt ON q_ans.quiz_alternative_id = q_alt.id
          WHERE q_ans.quiz_question_id = 101),
        q_states AS (
          SELECT q_submission.id, q_alt.description state
          FROM q_submission
          INNER JOIN quiz_answers q_ans ON q_submission.id = q_ans.quiz_form_submission_id
          INNER JOIN quiz_alternatives q_alt ON q_ans.quiz_alternative_id = q_alt.id
          WHERE q_ans.quiz_question_id = 102
        ),
        q_events AS (
            SELECT id, user_id
            FROM crm_events
            WHERE crm_events.id >= 7000000
              AND created_at BETWEEN #{sanitized_dates}
              AND event_name = 'campaign_view'
              AND campaign_view_name = 'quecurso'
        ),
        q_user AS (
          SELECT users.id,
                 users.name,
                 users.email,
                 users.birth_date,
                 users.phone_area,
                 users.phone_number,
                 addresses.city,
                 addresses.state
          FROM users
          LEFT JOIN addresses ON addresses.addressable_id = users.id AND addresses.addressable_type = 'User'
      )
       SELECT q_submission.user_id,
              q_user.name,
              q_user.email,
              q_user.birth_date,
              concat(q_user.phone_area || '', q_user.phone_number || '') phone,
              q_user.city,
              q_user.state,
              CASE
                WHEN MIN(q_events.id) IS NOT NULL THEN 'quecurso'
                ELSE 'mesalva'
              END as origin,
              array_agg(q_submission.created_at) as                      created_at,
              array_agg(q_courses.course || ' / ' || q_states.state)     answer
       FROM q_submission
       INNER JOIN q_courses ON q_submission.id = q_courses.id
       INNER JOIN q_states ON q_courses.id = q_states.id
       INNER JOIN q_user ON q_user.id = q_submission.user_id
       LEFT JOIN q_events ON q_events.user_id = q_submission.user_id
       GROUP BY q_submission.user_id, q_user.name, q_user.email, q_user.birth_date, phone, q_user.city, q_user.state
       ORDER BY created_at;
    SQL
  end

  def worker_start_date
    ENV['SISU_QUECURSO_LEADS_START_DATE']
  end

  def worker_end_date
    ENV['SISU_QUECURSO_LEADS_END_DATE']
  end
end
