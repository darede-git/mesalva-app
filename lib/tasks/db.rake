# frozen_string_literal: true

namespace :db do
  desc 'Tears down the database, rebuilds it from scratch using your migrations'
  task bootstrap: ['db:drop', 'db:create', 'db:migrate', 'db:seed']

  desc 'Copy production db to local'
  namespace :production do
    desc 'Avoid useless tables to development'
    task :lite do
      user_tables = %i[users essay_submissions essay_submission_transitions orders user_roles user_platforms discounts
                       instructor_users platform_vouchers permalink_events
                       campaign_events study_plans user_referrals cancellation_quizzes essay_events
                       accesses academic_infos crm_events enem_answer_grids favorites
                       partner_accesses instructors notification_events notifications
                       prep_test_scores playlists rates scholar_records quiz_form_submissions
                       subscriptions sisu_satisfactions sisu_scores vouchers quiz_answers
                       enem_answers study_plan_node_modules essay_marks pagarme_subscriptions
                       enem_answers playlist_permalinks order_payments essay_correction_checks
                       pagarme_transactions app_store_transactions play_store_transactions
                       prep_test_details prep_test_overviews]
      heroku_pull_command = "heroku pg:pull DATABASE_URL #{database_name}"
      exclude_table_data = "--exclude-table-data \"#{user_tables.join(';')}\""
      sh "#{heroku_pull_command} #{exclude_table_data} -a #{ENV['HEROKU_PRODUCTION_APP']}"
      ActiveRecord::Base.connection.tables.each do |table|
        ActiveRecord::Base.connection.execute("SELECT setval('#{table}_id_seq', (SELECT id + 1 FROM #{table} ORDER BY id DESC LIMIT 1));")
      rescue
        puts "error on set #{table}_id_seq"
      end
    end

    desc 'Download full database to local'
    task :full do
      Rake::Task['db:capture'].invoke
      Rake::Task['db:download'].invoke
      Rake::Task['db:dump_restore'].invoke
    end
  end

  desc 'Copy production db to staging'
  task :to_staging do
    heroku_app = "-a #{ENV['HEROKU_STAGING_APP']}"
    sh "heroku pg:copy #{ENV['HEROKU_PRODUCTION_APP']}::DATABASE_URL DATABASE_URL #{heroku_app}"
  end

  desc 'Download production backup'
  task :download do
    if File.exist? './tmp/pgbackups'
      backup_id = `grep -om1 "b[0-9]\\{3\\}" tmp/pgbackups`.strip
      all_backups = "heroku pg:backups public-url #{backup_id} -a #{ENV['HEROKU_PRODUCTION_APP']}"
      latest_url = `#{all_backups} | tail -n1`.strip
      system "curl -o latest.dump '#{latest_url.delete("'")}'"
    else
      puts 'tmp/pgbackups file not found, try running `db:capture`'
    end
  end

  desc 'Capture production backup'
  task :capture do
    begin
      sh "heroku pg:backups capture -a #{ENV['HEROKU_PRODUCTION_APP']}"
    rescue StandardError
      sh "heroku pg:backups:capture -a #{ENV['HEROKU_PRODUCTION_APP']}"
    end
    sh "heroku pg:backups -a #{ENV['HEROKU_PRODUCTION_APP']} | tee tmp/pgbackups"
  end

  desc 'Restore pg dump file'
  task :dump_restore do
    if File.exist? './latest.dump'
      pg_restore_command = "pg_restore -j 8 --verbose --clean --no-acl --no-owner -h localhost -d"
      system "#{pg_restore_command} #{database_name} #{database_user} #{database_port} latest.dump"
    else
      puts 'latest.dump file not found, try to pull it from production `db:production`'
    end
  end

  private

  def database_name
    Rails.configuration.database_configuration['development']['database']
  end

  def database_user
    user = Rails.configuration.database_configuration['development']['username']
    return '' unless user

    "-U #{user}"
  end

  def database_port
    port = Rails.configuration.database_configuration['development']['port']
    return '' unless port

    "-p #{port}"
  end
end
