# frozen_string_literal: true

RSpec.describe Bff::Cached::EssaysLiveClassesController, type: :controller do
  describe "GET #live_class " do
    before { Timecop.freeze("2022-06-02 12:00:00 -0300") }
    context "with some classes" do
      let!(:yesterday_class) do
        create(:item,
               :scheduled_streaming,
               starts_at: "2022-06-01 12:00:00",
               ends_at: "2022-06-01 13:00:00")
      end

      let!(:today_finished_class) do
        create(:item,
               :scheduled_streaming,
               starts_at: "2022-06-02 10:00:00",
               ends_at: "2022-06-02 11:00:00")
      end

      let!(:today_live_class) do
        create(:item,
               :scheduled_streaming,
               starts_at: "2022-06-02 11:00:00",
               ends_at: "2022-06-02 13:00:00")
      end

      let!(:today_upcoming_class) do
        create(:item,
               :scheduled_streaming,
               starts_at: "2022-06-02 15:00:00",
               ends_at: "2022-06-02 16:00:00")
      end

      let!(:tomorrow_class) do
        create(:item,
               :scheduled_streaming,
               starts_at: "2022-06-03 12:00:00",
               ends_at: "2022-06-03 13:00:00")
      end
      context 'a permalink' do
        let!(:permalink_today_finished_class) do
          create(:permalink,
                 medium_id: nil,
                 item: today_finished_class)
        end

        let!(:permalink_today_live_class) do
          create(:permalink,
                 medium_id: nil,
                 item: today_live_class)
        end

        let!(:permalink_today_upcoming_class) do
          create(:permalink,
                 medium_id: nil,
                 item: today_upcoming_class)
        end
        context.skip 'and a content teachear for todays class' do
          let!(:content_teacher_item_today_finished_class) do
            create(:content_teacher_item,
                   item: today_finished_class)
          end

          let!(:content_teacher_today_finished_class) do
            content_teacher_item_today_finished_class.content_teacher
          end

          let!(:content_teacher_item_today_live_class) do
            create(:content_teacher_item, item: today_live_class)
          end

          let!(:content_teacher_today_live_class) do
            content_teacher_item_today_live_class.content_teacher
          end

          let!(:content_teacher_item_today_upcoming_class) do
            create(:content_teacher_item, item: today_upcoming_class)
          end

          let!(:content_teacher_today_upcoming_class) do
            content_teacher_item_today_upcoming_class.content_teacher
          end

          it "returns only todays classes, todays lives classes and has live on information" do
            get :live_class

            today_lessons = parsed_response['results']['lessons']
            live_lessons = parsed_response['results']['lives']
            has_live_on = parsed_response['results']['hasLiveOn']
            today_lessons_expected = [create_class(
              msclass: today_finished_class,
              content_teacher: content_teacher_today_finished_class,
              status: :finished,
              permalink: permalink_today_finished_class
            ),

                                      create_class(
                                        msclass: today_live_class,
                                        content_teacher: content_teacher_today_live_class,
                                        permalink: permalink_today_live_class,
                                        status: :live
                                      ),

                                      create_class(
                                        msclass: today_upcoming_class,
                                        content_teacher: content_teacher_today_upcoming_class,
                                        permalink: permalink_today_upcoming_class,
                                        status: :upcoming
                                      )]

            live_lessons_expected = [create_class(
              msclass: today_live_class,
              content_teacher: content_teacher_today_live_class,
              permalink: permalink_today_live_class,
              status: :live
            )]

            expect(today_lessons.count).to eq(3)
            expect(today_lessons).to eq(today_lessons_expected)
            expect(live_lessons.count).to eq(1)
            expect(live_lessons).to eq(live_lessons_expected)
            expect(has_live_on).to eq(true)
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

  # rubocop:disable Metrics/AbcSize
  def create_class(**attrs)
    { "isCurrentDay" => true,
      "day" => t("date.day_names")[Date.today.strftime('%w').to_i],
      "shortDay" => t("date.abbr_day_names")[Date.today.strftime('%w').to_i],
      "startsAt" => format_date(attrs[:msclass].starts_at),
      "endsAt" => format_date(attrs[:msclass].ends_at),
      "title" => attrs[:msclass].name,
      "hour" => format_hours(attrs[:msclass].starts_at, attrs[:msclass].ends_at),
      "date" => attrs[:msclass].starts_at.strftime('%Y-%m-%d'),
      "status" => attrs[:status].to_s,
      "marsIcon" => { "name" => status_icons[attrs[:status].to_sym][:name],
                      "color" => status_icons[attrs[:status].to_sym][:color] },
      "image" => [attrs[:content_teacher]['image']],
      "teacherNamesFormated" => [attrs[:content_teacher].name.titleize],
      "href" => attrs[:permalink].slug }
  end
  # rubocop:enable Metrics/AbcSize
end
