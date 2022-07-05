# frozen_string_literal: true

class Bff::Cached::EssaysLiveClassesController < Bff::Cached::BffCachedBaseController
  STATUS_ICONS = { upcoming: { name: "clock",
                               color: "var(--color-warning-500)" },
                   live: { name: "live-circle",
                           color: "var(--color-primary-500)" },
                   finished: { name: "checkmark-circle",
                               color: "var(--color-neutral-500)" } }.freeze

  def live_class
    fetcher = -> { create_result(today_lessons) }
    render_cached(fetcher)
  end

  private

  def now_with_timezone
    DateTime.now - ENV["TIME_ZONE_OFFSET_HOURS"].to_i.hours
  end

  def mars_icon_from_lesson(lesson)
    mars_icon(status(lesson))
  end

  def today_lessons
    Item.live_classes_of_the_day(now_with_timezone).map do |lesson|
      { isCurrentDay: true,
        day: day,
        shortDay: short_day,
        startsAt: starts_at(lesson),
        endsAt: ends_at(lesson),
        title: title(lesson),
        hour: hour(lesson),
        date: date(lesson),
        status: status(lesson),
        marsIcon: mars_icon_from_lesson(lesson),
        image: images(lesson),
        teacherNamesFormated: teacher_name_formated(lesson),
        href: href(lesson) }
    end
  end

  def create_result(today_lessons)
    live_lessons = today_lessons.select { |lesson| lesson[:status] == 'live' }
    { lessons: today_lessons,
      lives: live_lessons,
      hasLiveOn: live_on?(live_lessons) }
  end

  def day
    t("date.day_names")[Date.today.strftime('%w').to_i]
  end

  def short_day
    t("date.abbr_day_names")[Date.today.strftime('%w').to_i]
  end

  def starts_at(lesson)
    lesson.starts_at
  end

  def ends_at(lesson)
    lesson.ends_at
  end

  def title(lesson)
    lesson.name
  end

  def hour(lesson)
    "Das #{lesson.starts_at.strftime('%H:%M')} às #{lesson.ends_at.strftime('%H:%M')}"
  end

  def date(lesson)
    lesson.starts_at.strftime('%Y-%m-%d')
  end

  def status(lesson)
    return 'upcoming' if upcoming_class?(lesson)

    return 'live' if live_class?(lesson)

    'finished' if finished_class?(lesson)
  end

  def upcoming_class?(lesson)
    lesson.starts_at.strftime('%H:%M') > Time.now.strftime('%H:%M')
  end

  def live_class?(lesson)
    lesson.starts_at.strftime('%H:%M') < Time.now.strftime('%H:%M') &&
      lesson.ends_at.strftime('%H:%M') > Time.now.strftime('%H:%M')
  end

  def finished_class?(lesson)
    lesson.ends_at.strftime('%H:%M') < Time.now.strftime('%H:%M')
  end

  def mars_icon(status)
    STATUS_ICONS[status.to_sym]
  end

  def images(lesson)
    lesson.content_teachers.map { |teacher| teacher['image'] }
  end

  def teacher_name_formated(lesson)
    lesson.content_teachers.map { |teacher| teacher.name.titleize }
  end

  def href(lesson)
    lesson.main_permalink.slug
  end

  def live_on?(live_lessons)
    live_lessons.count.positive?
  end

  def end_of_week
    Date.today.end_of_week.strftime('%Y-%m-%d')
  end
end
