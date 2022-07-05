# frozen_string_literal: true

module MeSalva
  module Schedules
    class Bookings < Client
      def initialize
        super
        @mentorings = []
      end

      def sync_next_bookings(page = 1)
        page += 1 while sync_next_bookings_page(page)
        @mentorings
      end

      def sync_next_bookings_page(page)
        @response = get_request("bookings?filter[upcoming_only]=1&page=#{page}")

        @response["data"].each do |simple_booking|
          @booking = simple_booking
          treat_one_booking
        end

        @response["metadata"]["pages_count"] > page
      end

      def debug
        { response:@response, booking: @booking }
      end

      private

      def invalid_booking?
        @booking['client'].nil? || !@booking['client']['email'].present? ||
          @booking['provider'].nil? || !@booking['provider']['email'].present?
      end

      def match_db_data?
        @user.present? && @content_teacher.present?
      end

      def treat_one_booking
        return nil if invalid_booking?

        @user = ::User.find_by_crm_email(@booking['client']['email'])
        @content_teacher = ContentTeacher.find_by_email(@booking['provider']['email'])

        @mentorings << create_or_update_mentoring if match_db_data?
      end

      def create_or_update_mentoring
        @booking = get_request("bookings/#{@booking['id']}")

        service = @booking['service']
        link_field = @booking['additional_fields'].find { |field| /^link/i.match(field['field_name'])}

        data = {
          title: service['name'],
          status: @booking['status'],
          user_id: @user.id,
          content_teacher_id: @content_teacher.id,
          comment: service['description'],
          simplybook_id: @booking['id'],
          starts_at: @booking['start_datetime'],
          call_link: link_field.nil? ? nil : link_field['value']
        }
        mentoring = Mentoring.find_by_simplybook_id(@booking['id'])

        return Mentoring.create(data) if mentoring.nil?

        mentoring.update(data)
      end
    end
  end
end


