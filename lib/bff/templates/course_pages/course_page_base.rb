# frozen_string_literal: true

module Bff
  module Templates
    module CoursePages
      class CoursePageBase
        def initialize(course_slug)
          @course_slug = course_slug
        end

        def fetch_summary
          @summary = fetch_file("#{@course_slug}/summary.json")
        end

        def fetch_page(page = nil)
          @page_number = page || (Date.today.cweek - week_offset + 1).to_i
          @page_number = 1 if page_number < 0 && @summary['releasePage'].nil?
          begin
            @page = fetch_file("#{@course_slug}/#{@page_number.to_s.rjust(3, '0')}.json")
          rescue
            @page = nil
          end
        end

        def fetch_file(file_path)
          MeSalva::Aws::File.read_json("courses/enem-e-vestibulares/#{file_path}", "data/")
        end

        def week_offset
          @summary['weekOffset'] || 6
        end

        def page_number
          @page_number.to_i
        end
      end
    end
  end
end
