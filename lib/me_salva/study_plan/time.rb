# frozen_string_literal: true

module MeSalva
  module StudyPlan
    class Time
      include FirstDayHelper

      SHIFT_DURATION = {
        morning: ENV['STUDY_PLAN_MORNING_SHIFT_DURATION'].to_i,
        mid: ENV['STUDY_PLAN_MID_SHIFT_DURATION'].to_i,
        evening: ENV['STUDY_PLAN_EVENING_SHIFT_DURATION'].to_i
      }.freeze
      SHIFT_STARTS_AT = {
        morning: ::Time.mktime(2000, 1, 1, 8, 0),
        mid: ::Time.mktime(2000, 1, 1, 13, 0),
        evening: ::Time.mktime(2000, 1, 1, 18, 0)
      }.freeze

      def initialize(shifts, starts_at, ends_at)
        @shifts = shifts
        @starts_at = starts_at
        @ends_at = ends_at
      end

      def availability
        full_weeks_total_hours + remaining_days_hours + first_day_hours
      end

      def full_weeks_total_hours
        @full_weeks_total_hours ||= full_weeks * weekday_hours_sum
      end

      def remaining_days_hours
        current_weekday = second_day_weekday
        remaining_days_hours = 0
        remaining_days.times do
          remaining_days_hours += weekday_hours[current_weekday]
          current_weekday += 1 unless current_weekday == 6
          current_weekday = 0 if current_weekday == 6
        end
        remaining_days_hours
      end

      def first_day_hours
        return remaining_evening_time if evening? && first_day_include_evening?

        return remaining_hours_from_mid if mid?

        return remaining_hours_from_morning if morning?

        full_first_day_hours
      end

      private

      def weekday_hours
        @weekday_hours ||= parse_weekday_hours
      end

      def shift_start(shift)
        SHIFT_STARTS_AT[shift]
      end

      %w[morning mid evening].each do |m|
        define_method("#{m}_duration") { SHIFT_DURATION[m.to_sym] }
      end

      def weekday_hours_sum
        @weekday_hours_sum ||= weekday_hours.values.sum
      end

      def total_days
        @total_days ||= (@ends_at.to_date - @starts_at.to_date).to_i + 1
      end

      def full_days
        @full_days ||= total_days - 2
      end

      def full_weeks
        @full_weeks ||= (full_days / 7).to_i
      end

      def remaining_days
        @remaining_days ||= full_days % 7
      end

      def second_day_weekday
        @second_day_weekday ||= (@starts_at.to_date + 1.day).wday
      end

      def shift_hours_sum
        SHIFT_DURATION.values.sum
      end

      def morning?
        ::Time.mktime(2000, 1, 1, @starts_at.hour, @starts_at.min)
              .between?(shift_start(:morning), shift_start(:mid))
      end

      def mid?
        ::Time.mktime(2000, 1, 1, @starts_at.hour, @starts_at.min)
              .between?(shift_start(:mid), shift_start(:evening))
      end

      def evening?
        ::Time.mktime(2000, 1, 1, @starts_at.hour, @starts_at.min) >=
          shift_start(:evening)
      end

      def parse_weekday_hours
        weekdays = { 0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0 }
        @shifts.each_with_object(weekdays) do |pair, week|
          day = pair.keys.first
          shift = pair[day]
          week[day] += SHIFT_DURATION[shift]
        end
      end
    end
  end
end
