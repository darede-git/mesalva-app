class UserCounter < ActiveRecord::Base
  belongs_to :user
  after_initialize :set_default_values

  ALLOWED_TYPES = %w[video exercise essay text book streaming public_document essay].freeze

  def self.increment_by_user_token(user, medium_type)
    counters = UserCounter.user_date_counters(user)
    counters.map do |counter|
      counter[medium_type] += 1
      counter.save
    end
  end

  def self.increment_by_event_name(user, event_name)
    medium_type = UserCounter.medium_type_by_event_name(event_name)
    return nil unless medium_type

    UserCounter.increment_by_user_token(user, medium_type)
  end

  def self.current_periods
    date = Date.today
    year = date.year.to_s
    month = date.month
    {
      day: "#{year}-#{month}-#{date.day}",
      week: "#{year}/#{date.strftime('%U')}",
      month: "#{year}-#{month}",
      year: year
    }
  end

  def self.date_period_by_type(period_type, date = nil)
    return date if date.is_a?(Integer)

    current_periods[period_type.to_sym]
  end

  def self.user_date_period(user, period_type, date = nil)
    period = date_period_by_type(period_type, date)
    UserCounter.where(period_type: period_type, user: user, period: period).first
  end

  def self.find_or_create(user, period_type, date = nil)
    period = date_period_by_type(period_type, date)
    counter = UserCounter.where(user: user, period: period, period_type: period_type).first
    return counter unless counter.nil?

    UserCounter.new(user: user, period: period, period_type: period_type)
  end

  def self.user_date_counters(user)
    periods = UserCounter.current_periods
    periods.map do |period_type, period|
      UserCounter.find_or_create(user, period_type, period)
    end
  end

  def set_default_values
    UserCounter::ALLOWED_TYPES.each { |type| self[type] ||= 0 }
  end


  def self.medium_type_by_event_name(event_name)
    valid_translations = {
      lesson_watch: :video,
      text_read: :text,
      exercise_answer: :exercise,
      public_document_read: :public_document,
      book_read: :book,
    }
    valid_translations[event_name.to_sym]
  end
end
