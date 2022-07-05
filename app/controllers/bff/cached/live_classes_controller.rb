# frozen_string_literal: true

class Bff::Cached::LiveClassesController < Bff::Cached::BffCachedBaseController
  def weekly
    fetcher = lambda {
      @offset = params[:offset].to_i
      date_week
      @lessons = lessons
      all_classes_week
    }
    render_cached(fetcher)
  end

  def date_week
    @week_beginning = valid_offset.beginning_of_week(:sunday).strftime('%Y-%m-%d')
    @week_end = valid_offset.end_of_week(:sunday).strftime('%Y-%m-%d')
  end

  def date_helper
    MeSalva::DateHelper
  end

  def valid_offset
    Date.today + @offset.weeks
  end

  def lessons
    Item.where("starts_at >= ?", @week_beginning)
        .where("ends_at <= ?", @week_end)
        .where(item_type: 'streaming')
  end

  def all_classes_week
    {
      title: "#{@week_beginning} a #{@week_end}",
      navigation:
                {
                  current: @offset,
                  next: @offset + 1,
                  previous: @offset - 1
                },
      week: lessons_weekly

    }
  end

  # rubocop:disable Metrics/AbcSize
  def lessons_weekly
    result = []
    @lessons.each do |item|
      live_class = Bff::Lessons::LessonInformationCompiler.new(item)
      result << {
        object_date:
            {
              day_of_week: date_helper.wday_name(item.starts_at),
              short_day: date_helper.wday_name(item.starts_at, true),
              month_name: date_helper.month_name(item.starts_at),
              day: item.starts_at.strftime('%d'),
              month: item.starts_at.strftime('%m'),
              year: item.starts_at.strftime('%y')
            },
        title: title_lesson(item),
        is_current_day: item.starts_at.today?,
        lessons:
        [lesson(item, live_class)]
      }
    end
    result
  end

  # rubocop:enable Metrics/AbcSize
  def lesson(item, live_class)
    {
      is_current_day: item.starts_at.today?,
      day: day_lesson(item),
      short_day: date_helper.wday_name(item.starts_at, true),
      starts_at: item.starts_at,
      ends_at: item.ends_at,
      title: item.name,
      hour: time_lesson(item),
      date: item.starts_at.strftime('%Y-%m-%d'),
      status: live_class.status,
      mars_icon: live_class.mars_icon,
      image: live_class.images,
      teacher_names_formated: live_class.teacher_name_formated,
      href: live_class.href
    }
  end

  # rubocop:disable Layout/LineLength
  def title_lesson(item)
    "#{date_helper.wday_name(item.starts_at)}, #{item.starts_at.strftime('%d')}/#{item.starts_at.strftime('%m')}"
  end
  # rubocop:enable Layout/LineLength

  def day_lesson(item)
    t("date.day_names")[item.starts_at.strftime('%w').to_i]
  end

  def time_lesson(item)
    "Das #{item.starts_at.strftime('%H:%M')} às #{item.ends_at.strftime('%H:%M')}"
  end
end
