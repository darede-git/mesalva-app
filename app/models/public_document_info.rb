# frozen_string_literal: true

class PublicDocumentInfo < ActiveRecord::Base
  belongs_to :item
  belongs_to :major
  belongs_to :college

  ALLOWED_TYPES = %w[test summary mind_map text_book book schoolwork].freeze

  validates :document_type, inclusion: { in: ALLOWED_TYPES }
end
