# frozen_string_literal: true

module MeSalva
  class Canonical
    LISTABLE_ATTRIBUTES = %w[slug].freeze

    def initialize(file_name)
      @file_name = file_name
    end

    def insert_from_csv
      @header = csv_content.delete_at(0)
      validate_header
      csv_content.each do |content_row|
        create_canonical(content_row)
      end
      logger.save
    end

    private

    def create_canonical(attributes)
      new_canonical = CanonicalUri.new(canonical_attributes(attributes))
      message = if new_canonical.save
                  creation_success_message(attributes[0])
                else
                  creation_failure_message(attributes[0], new_canonical.errors)
                end
      logger.append(message)
    end

    def csv_content
      @csv_content ||= MeSalva::Aws::Csv.read(@file_name)
    end

    def validate_header
      raise MeSalva::Error::NonexistentColumnError unless valid_header?
    end

    def valid_header?
      (@header - LISTABLE_ATTRIBUTES).empty?
    end

    def canonical_attributes(attributes)
      @header.each_with_object({}).with_index do |(attr, hash), index|
        hash[attr] = attributes[index]
      end
    end

    def creation_success_message(canonical_slug)
      I18n.t('canonicals.success_creation', slug: canonical_slug)
    end

    def creation_failure_message(canonical_slug, error)
      I18n.t('canonicals.error_creation', slug: canonical_slug,
                                          error: error.messages)
    end

    def logger
      @logger ||= MeSalva::Aws::Log.new(@file_name)
    end
  end
end
