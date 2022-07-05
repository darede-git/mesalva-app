# frozen_string_literal: true

module MeSalva
  module Aws
    class Csv
      CSV_EXTENTION = '.csv'

      def self.read(file_name)
        file_content = open_file(file_name)
        CSV.parse(format_content(file_content))
      end

      def self.format_name(file_name)
        return file_name if file_name.end_with?(CSV_EXTENTION)

        "#{file_name}#{CSV_EXTENTION}"
      end

      def self.format_content(content)
        content.delete("\r").force_encoding("UTF-8")
      end

      def self.open_file(file_name)
        file_name = format_name(file_name)
        MeSalva::Aws::File.read(file_name)
      end

      private_class_method :format_name, :format_content, :open_file
    end
  end
end
