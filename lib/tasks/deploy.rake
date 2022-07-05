# frozen_string_literal: true
namespace :deploy do
  desc 'Backend deploy'
  task :staging do
    deploy(staging_app_name)
  end

  task :production do
    deploy(production_app_name)
  end

  task :develop do
    deploy(develop_app_name)
  end

  task :last_staging_release do
    last_release(staging_app_name)
  end

  task :last_production_release do
    last_release(production_app_name)
  end

  task :staging_releases do
    system releases(staging_app_name)
  end

  task :production_releases do
    system releases(production_app_name)
  end

  namespace :rollback do
    desc 'Rollback staging deploy'
    task :staging do
      rollback(staging_app_name)
    end

    desc 'Rollback production deploy'
    task :production do
      rollback(production_app_name)
    end
  end

  private


  def branch
    ENV['BRANCH'] || current_branch
  end

  def staging_app_name
    ENV['HEROKU_STAGING_APP']
  end

  def production_app_name
    ENV['HEROKU_PRODUCTION_APP']
  end

  def develop_app_name
    ENV['HEROKU_DEVELOP_APP']
  end

  def current_branch
    `git rev-parse --abbrev-ref HEAD`.strip
  end

  def deploy(app)
    system "git push -f #{app} #{branch}:master"
    system "heroku run rake db:migrate -a #{app}"
    system "heroku restart -a #{app}"
    last_release(app)
    trigger_webhook(app)
  end

  def rollback(app)
    system "heroku rollback -a #{app}"
    system "heroku run rake db:rollback -a #{app}"
    system "heroku restart -a #{app}"
    last_release(app)
    trigger_webhook(app)
  end

  def last_release(app)
    system releases(app) + ' | grep -om 1 "[0-9a-f]\{7\}" | xargs git log -1 --oneline'
  end

  def releases(app)
    "heroku releases -a #{app}"
  end

  def trigger_webhook(app)
    `curl --silent -X POST --data-urlencode 'payload={"channel": "#deploys", \
"username": "Backend", "text": "Deploy de *#{app}* realizado por \
*#{git_user}*. Último commit: https://github.com/mesalva/backend-api/commit/\
#{last_local_commit}", "icon_emoji": ":white_check_mark:"}' \
https://hooks.slack.com/services/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 \
> /dev/null &`
  end

  def git_user
    `git config user.email`.split('@').first
  end

  def last_local_commit
    `git log --oneline -n 1 --no-color`.strip.gsub!('\'', '')
  end
end
