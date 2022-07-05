# frozen_string_literal: true

module MeSalva
  module StudyPlan
    module FirstDayHelper
      def remaining_morning_time
        remaining_time = shift_start(:mid).hour - @starts_at.hour
        return morning_duration if remaining_time > shift_start(:morning).hour

        remaining_time
      end

      def remaining_mid_time
        remaining_time = shift_start(:evening).hour - @starts_at.hour
        return mid_duration if remaining_time > mid_duration

        remaining_time
      end

      def remaining_evening_time
        remaining_time = 24 - @starts_at.hour
        return evening_duration if remaining_time > evening_duration

        remaining_time
      end

      def full_first_day_hours
        (first_day_include_morning? ? morning_duration : 0) +
          (first_day_include_mid? ? mid_duration : 0) +
          (first_day_include_evening? ? evening_duration : 0)
      end

      def remaining_hours_from_mid
        (first_day_include_mid? ? remaining_mid_time : 0) +
          (first_day_include_evening? ? evening_duration : 0)
      end

      def remaining_hours_from_morning
        (first_day_include_morning? ? remaining_morning_time : 0) +
          (first_day_include_mid? ? mid_duration : 0) +
          (first_day_include_evening? ? evening_duration : 0)
      end

      %w[morning mid evening].each do |shift|
        define_method("first_day_include_#{shift}?") do
          @shifts.include?(@starts_at.wday => shift.to_sym)
        end
      end
    end
  end
end
