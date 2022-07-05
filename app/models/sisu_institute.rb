# frozen_string_literal: true

class SisuInstitute < ActiveRecord::Base
  include SisuInstitutesWeightingsQuery
  include SisuInstitutesChancesQuery
  default_scope { order(passing_score: :asc) }
end
