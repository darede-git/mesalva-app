# frozen_string_literal: true

module ElasticIndexHelper
  extend ActiveSupport::Concern
  def as_indexed_json(_options = {})
    attributes.merge(utm_source: utm.try(:utm_source),
                     utm_medium: utm.try(:utm_medium),
                     utm_term: utm.try(:utm_term),
                     utm_content: utm.try(:utm_content),
                     utm_campaign: utm.try(:utm_campaign)).as_json
  end
end
