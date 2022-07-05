# frozen_string_literal: true

require 'zip'
require 'open-uri'

module MeSalva
  module Aws
    class Unzip
      def unzip_medium(medium_slug)
        @attachment = Medium.find_by_slug(medium_slug).attachment
        @store_dir = @attachment.path.gsub('.zip', '')
        unzip
      end

      private

      def unzip
        Zip.unicode_names = true
        Zip.force_entry_names_encoding = 'UTF-8'

        Zip::File.open(get_file(@attachment.url)) do |zip_file|
          zip_file.each do |entry|
            next if invalid_file(entry)

            @file_path = destination_file(entry.name)
            write(entry, zip_file)
          end
        end
      end

      def invalid_file(file)
        return true if file.ftype.eql?(:directory)

        regexed_file = %r{((pageflipdata|css|js)/.*|index.html)}.match(file.name)
        regexed_file.nil?
      end

      def get_file(url)
        open(url)
      end

      def destination_file(file)
        regexed_file = %r{((pageflipdata|css|js)/.*|index.html)}.match(file)
        regexed_file.nil? ? false : "#{@store_dir}/#{regexed_file}"
      end

      def already_exists?(file)
        return false unless file || extension?(file)

        bucket = connection.directories.get(ENV['S3_BUCKET'])
        bucket&.files&.get(file)
      end

      def extension?(file)
        !File.extname(file).blank?
      end

      def write(file_content, zip_file)
        return if already_exists?(@file_path)

        @body = file_content.get_input_stream.read
        Rails.env.test? ? write_local(file_content, zip_file) : write_aws
      end

      def write_aws
        directory = connection.directories.get(ENV['S3_BUCKET'])
        file = directory.files.new(key: @file_path, body: @body, public: true)
        file.save
      end

      def write_local(entry, zip_file)
        FileUtils.mkdir_p(Kgio::File.dirname(@file_path))
        zip_file.extract(entry, @file_path) unless Kgio::File.exist?(@file_path)
      end

      def connection
        Fog::Storage.new(provider: 'AWS',
                         aws_access_key_id: ENV['AMAZON_ACCESS_KEY_ID'],
                         aws_secret_access_key: ENV['AMAZON_SECRET_ACCESS_KEY'])
      end
    end
  end
end
