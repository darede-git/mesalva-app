# frozen_string_literal: true

RSpec.describe Bff::Cached::LiveClassesController, type: :controller do
  describe 'GET #live_class_weekly_controller' do
    before { Timecop.freeze("2022-06-20 12:00:00 -0300") }
    context 'for a json' do
      context 'get lives for weekly' do
        let!(:class1) do
          create(:item,
                 :scheduled_streaming,
                 starts_at: "2022-06-20",
                 ends_at: "2022-06-20")
        end
        let!(:class2) do
          create(:item,
                 :scheduled_streaming,
                 starts_at: "2022-06-22",
                 ends_at: "2022-06-22")
        end

        context 'a permalink' do
          let!(:permalink_class1) do
            create(:permalink,
                   medium_id: nil,
                   item: class1)
          end

          let!(:permalink_class2) do
            create(:permalink,
                   medium_id: nil,
                   item: class2)
          end

          context 'and a content teachear class' do
            let!(:content_teacher_item_class1) do
              create(:content_teacher_item,
                     item: class1)
            end

            let!(:content_teacher_class1) do
              content_teacher_item_class1.content_teacher
            end

            let!(:content_teacher_item_class2) do
              create(:content_teacher_item,
                     item: class2)
            end

            let!(:content_teacher_class2) do
              content_teacher_item_class2.content_teacher
            end

            it 'weekly_essay' do
              get :weekly, params: { offset: 0 }

              weekly_lessons = parsed_response['results']['week']
              weekly_lessons_expected = [expected_lesson(msclass: class1,
                                                         content_teacher: content_teacher_class1,
                                                         status: :finished,
                                                         permalink: permalink_class1,
                                                         item: class1,
                                                         is_current_day: true),
                                         expected_lesson(msclass: class2,
                                                         content_teacher: content_teacher_class2,
                                                         status: :finished,
                                                         permalink: permalink_class2,
                                                         item: class2,
                                                         is_current_day: false)]
              expect(weekly_lessons.count).to eq(2)

              expect(weekly_lessons).to eq(weekly_lessons_expected)
            end
          end
        end
      end
    end
  end

  def status_icons
    {
      upcoming: { name: "clock", color: "var(--color-warning-500)" },
      live: { name: "live-circle", color: "var(--color-primary-500)" },
      finished: { name: "checkmark-circle", color: "var(--color-neutral-500)" }
    }
  end

  def format_date(date)
    "#{date.strftime('%Y-%m-%d')}T#{date.strftime('%H:%M:%S')}.000Z"
  end

  def format_hours(begins_date, end_date)
    "Das #{begins_date.strftime('%H:%M')} às #{end_date.strftime('%H:%M')}"
  end

  def date_helper
    MeSalva::DateHelper
  end

  # rubocop:disable Metrics/AbcSize
  def expected_lesson(**attrs)
    msclass = attrs[:msclass]
    day_of_week = date_helper.wday_name(msclass.starts_at)
    day = msclass.starts_at.strftime('%d')
    month = msclass.starts_at.strftime('%m')
    { "object_date" => { "day_of_week" => day_of_week,
                         "short_day" => date_helper.wday_name(msclass.starts_at, true),
                         "month_name" => date_helper.month_name(msclass.starts_at),
                         "day" => day,
                         "month" => month,
                         "year" => msclass.starts_at.strftime('%y') },
      "title" => "#{day_of_week}, #{day}/#{month}",
      "is_current_day" => msclass.starts_at.today?,
      "lessons" => [expected_lesson_row(msclass, attrs)] }
  end

  def expected_lesson_row(msclass, attrs)
    {
      "is_current_day" => attrs[:is_current_day],
      "day" => t("date.day_names")[msclass.starts_at.strftime('%w').to_i],
      "short_day" => t("date.abbr_day_names")[msclass.starts_at.strftime('%w').to_i],
      "starts_at" => format_date(msclass.starts_at),
      "ends_at" => format_date(msclass.ends_at),
      "title" => msclass.name,
      "hour" => format_hours(msclass.starts_at, msclass.ends_at),
      "date" => msclass.starts_at.strftime('%Y-%m-%d'),
      "status" => attrs[:status].to_s,
      "mars_icon" => { "name" => status_icons[attrs[:status].to_sym][:name],
                       "color" => status_icons[attrs[:status].to_sym][:color] },
      "image" => [attrs[:content_teacher]['image']],
      "teacher_names_formated" => [attrs[:content_teacher].name.titleize],
      "href" => attrs[:permalink].slug
    }
  end
  # rubocop:enable Metrics/AbcSize
end
