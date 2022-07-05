# frozen_string_literal: true

class ChangeHstoreToJsonbFields < ActiveRecord::Migration[5.2]
    def change
      change_column :cancellation_quizzes, :quiz, :jsonb, using: 'quiz::jsonb'
      change_column :essay_marks, :coordinate, :jsonb, using: 'coordinate::jsonb'
      change_column :essay_events, :grades, :jsonb, using: 'grades::jsonb'
      change_column :essay_submissions, :grades, :jsonb, using: 'grades::jsonb'
      change_column :essay_submissions, :appearance, :jsonb, using: 'appearance::jsonb'
      change_column :orders, :broker_data, :jsonb, using: 'broker_data::jsonb'
    end
  end