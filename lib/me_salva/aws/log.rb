# frozen_string_literal: true

module MeSalva
  module Aws
    class Log
      def initialize(file_name)
        @file_name = formatted_file_name(file_name)
        @log = []
      end

      def append(line)
        @log.push(line)
      end

      def save
        MeSalva::Aws::File.write(@file_name, formatted_content)
      end

      private

      def formatted_file_name(file_name)
        "#{file_name}_log_#{Time.now}.txt"
      end

      def formatted_content
        @log.join("\n")
      end
    end
  end
end
