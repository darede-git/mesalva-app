# frozen_string_literal: true

require 'open-uri'

module MeSalva
  module Aws
    class File
      def self.read(file_name, path = nil)
        url = "#{file_path(path)}#{file_name}"
        open_file(url)
      end

      def self.read_json(file_name, path = 'data/')
        JSON.parse(self.read(file_name, path))
      end

      def self.write(file_name, file_content, options = {})
        bucket = options['bucket'] || ENV['S3_BUCKET']
        file_path = options['file_path'] || ENV['AMAZON_BUCKET_FILES_PATH']
        public = options['public'] || true

        directory = connection.directories.get(bucket)
        file = directory.files.new(
          key: formated_file_name(file_name, file_path),
          body: file_content,
          public: public
        )
        file.save
      end

      def self.formated_file_name(file_name, file_path)
        "#{file_path}#{file_name}"
      end

      def self.connection
        Fog::Storage.new(
          provider: 'AWS', aws_access_key_id: ENV['AMAZON_ACCESS_KEY_ID'],
          aws_secret_access_key: ENV['AMAZON_SECRET_ACCESS_KEY']
        )
      end

      def self.file_path(path = nil)
        base = "#{ENV['S3_URL']}#{ENV['S3_BUCKET']}/"
        return "#{base}#{ENV['AMAZON_BUCKET_FILES_PATH']}" if path.nil?

        "#{base}#{path}"
      end

      def self.open_file(url)
        open(url).read
      end

      private_class_method :formated_file_name, :connection, :file_path,
                           :open_file
    end
  end
end
