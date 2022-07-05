# frozen_string_literal: true

class StudyPlanStructureWorker
  include Sidekiq::Worker

  def perform(attrs)
    MeSalva::StudyPlan::Structure
      .new(parsed(attrs))
      .build
  end

  def parsed(attrs)
    parsed_attrs = instance_eval(attrs)
    parsed_attrs[:shifts] = sanitize(parsed_attrs[:shifts])

    parsed_attrs
  end

  def sanitize(shifts)
    shifts.map(&:to_hash)
          .map { |h| { h.keys.first.to_s.to_i => h.values.first.to_sym } }
  end
end
