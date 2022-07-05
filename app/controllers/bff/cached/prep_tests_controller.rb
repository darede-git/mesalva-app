# frozen_string_literal: true

class Bff::Cached::PrepTestsController < Bff::Cached::BffCachedBaseController
  def show_weekly
    fetcher = -> do
      all_prep_tests = JSON.parse(MeSalva::Aws::File.read("schedules/weekly-prep-tests.json", 'data/'))
      all_prep_tests.detect do |week|
        current_date = MeSalva::DateHelper.now_with_offset.strftime('%Y-%m-%d')
        current_date >= week['startsAt'] && current_date <= week['expiresAt']
      end
    end
    render_cached(fetcher)
  end
end
