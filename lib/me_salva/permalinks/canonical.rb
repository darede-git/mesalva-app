# frozen_string_literal: true

module MeSalva
  module Permalinks
    class Canonical
      FILE_ATTRIBUTES = %w[slug canonical_uri].freeze

      def initialize(file_name)
        @file_name = file_name
      end

      def update_from_csv
        @header = csv_content.delete_at(0)
        validate_header
        csv_content.each do |content_row|
          content_row = row_to_hash(content_row)
          slug = content_row['slug']
          canonical_uri = content_row['canonical_uri']
          update_canonization(slug, canonical_uri)
        end
        logger.save
      end

      private

      def csv_content
        @csv_content ||= MeSalva::Aws::Csv.read(@file_name)
      end

      def validate_header
        raise MeSalva::Error::NonexistentColumnError unless valid_header?
      end

      def valid_header?
        (@header & FILE_ATTRIBUTES) == FILE_ATTRIBUTES
      end

      def update_canonization(slug, canonical_uri)
        permalink = ::Permalink.find_by_slug(slug)
        message = if permalink.nil?
                    permalink_not_found_message(slug)
                  elsif permalink.update(canonical_uri: canonical_uri)
                    success_canonization_message(slug)
                  else
                    failure_canonization_message(slug, permalink.errors)
                  end
        logger.append(message)
      end

      def row_to_hash(row)
        @header.each_with_object({}).with_index do |(attr, hash), index|
          hash[attr] = row[index]
        end
      end

      def permalink_not_found_message(slug)
        I18n.t('activerecord.errors.models.permalink.not_found', slug: slug)
      end

      def success_canonization_message(slug)
        I18n.t('activerecord.errors.models.permalink.success_canonization',
               slug: slug)
      end

      def failure_canonization_message(slug, errors)
        I18n.t('activerecord.errors.models.permalink.failure_canonization',
               slug: slug, errors: errors.messages)
      end

      def logger
        @logger ||= MeSalva::Aws::Log.new(@file_name)
      end
    end
  end
end
