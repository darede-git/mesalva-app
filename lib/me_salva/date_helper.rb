# frozen_string_literal: true

module MeSalva
  class DateHelper
    def self.now_with_offset
      date_with_offset(DateTime.now)
    end

    def self.date_with_offset(date)
      return nil if date.nil?

      date - (ENV['TIME_ZONE_OFFSET_HOURS'] || '3').to_i.hours
    end

    def self.valid_date_with_fallback(date)
      return date if valid_date?(date)

      Time.at(0).to_date
    end

    def self.valid_date?(date)
      return false if date.nil?
      date >= '1900-01-01'.to_date
    end

    def self.wday_name(date, short = false)
      return false if date.nil?
      wday_name_by_index(date.wday, short)
    end

    def self.wday_name_by_index(index, short = false)
      key = short ? 'abbr_day_names' : 'day_names'
      I18n.t("date.#{key}")[index.to_i]
    end

    def self.month_name(date, short = false)
      return false if date.nil?
      key = short ? 'abbr_month_names' : 'month_names'
      I18n.t("date.#{key}")[date.month]
    end

    def self.beginning_of_day(date)
      date.strftime('%Y-%m-%d %H:%M:%S').to_datetime.beginning_of_day
    end

    def self.end_of_day(date)
      date.strftime('%Y-%m-%d %H:%M:%S').to_datetime.end_of_day
    end
  end
end
