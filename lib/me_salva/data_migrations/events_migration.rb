# frozen_string_literal: true

module MeSalva
  module DataMigrations
    class EventsMigration
      def migrate_by_user_id(user_id, forced = false)
        @user_id = user_id
        @lesson_events = {}
        @exercise_events = {}
        return nil if forced.nil? && user_already_migrated?

        user_setting.update(value: { status: 'migrating' })

        PermalinkEvent.joins('INNER JOIN answers ON answers.id = permalink_answer_id')
                      .where(user_id: @user_id).each { |event| add_event(event) }
        PermalinkEvent.where('user_id = :user_id AND permalink_answer_id IS NULL', user_id: @user_id)
                      .each { |event| add_event(event) }
        create_lesson_events if @lesson_events.present?
        create_exercise_events if @exercise_events.present?
        user_setting.update(value: { status: 'done' })
      end

      private

      def user_setting
        UserSetting.find_or_create(user_id: @user_id, key: 'user_events_migration_status')
      end

      def add_event(event)
        add_lesson_event(event)
        add_exercise_event(event)
      end

      def add_lesson_event(event)
        key = "#{event.permalink_node_module_slug}_#{event.permalink_item_slug}"
        @lesson_events[key] = group_clause(lesson_event_params(event))
      end

      def lesson_event_params(event)
        [@user_id, sql_string(event.permalink_node_module_slug),
         sql_string(event.permalink_item_slug), sql_string(event.submission_token),
         sql_string(event.created_at), sql_string(event.created_at)]
      end

      def add_exercise_event(event)
        key = "#{event.permalink_item_slug}_#{event.permalink_medium_slug}"
        key += "_#{event.submission_token}" if event.submission_token.present?
        @exercise_events[key] = group_clause(exercise_event_params(event))
      end

      def exercise_event_params(event)
        [@user_id, sql_integer(event.permalink_answer_id),
         sql_string(event.submission_token), sql_boolean(event.permalink_answer_correct),
         sql_string(event.permalink_item_slug), sql_string(event.permalink_medium_slug),
         sql_string(event.created_at), sql_string(event.created_at)]
      end

      def sql_integer(value)
        return 'NULL' if value.nil?

        value
      end

      def sql_boolean(value)
        return 'NULL' if value.nil?

        value.to_s
      end

      def sql_string(value)
        return 'NULL' if value.nil?

        "'#{value}'"
      end

      def user_already_migrated?
        user_setting = UserSetting.where(user_id: @user_id, key: 'user_events_migration_status')
        return false unless user_setting.count.positive?

        puts "###### Usuário já foi migrado #####"
        true
      end

      def create_lesson_events
        query = ["INSERT INTO", "lesson_events"]
        query << group_clause(%w[user_id node_module_slug item_slug
                                 submission_token created_at updated_at])
        query << "VALUES"
        query << @lesson_events.values.join(',')
        LessonEvent.where(user_id: @user_id).delete_all
        ActiveRecord::Base.connection.execute(query.join(' '))
      end

      def create_exercise_events
        query = ["INSERT INTO", "exercise_events"]
        query << group_clause(%w[user_id answer_id submission_token correct
                                 item_slug medium_slug created_at updated_at])
        query << "VALUES"
        query << @exercise_events.values.join(',')
        ExerciseEvent.where(user_id: @user_id).delete_all
        ActiveRecord::Base.connection.execute(query.join(' '))
      end

      def group_clause(fields)
        "(#{fields.join(',')})"
      end
    end
  end
end
