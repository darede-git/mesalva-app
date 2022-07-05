# frozen_string_literal: true
class AddCascadeToQuizForeignKeys < ActiveRecord::Migration[4.2]
  def change
    remove_foreign_key :quiz_questions, :quiz_forms
    add_foreign_key :quiz_questions, :quiz_forms, on_delete: :cascade

    remove_foreign_key :quiz_form_submissions, :quiz_forms
    add_foreign_key :quiz_form_submissions, :quiz_forms, on_delete: :cascade

    remove_foreign_key :quiz_alternatives, :quiz_questions
    add_foreign_key :quiz_alternatives, :quiz_questions, on_delete: :cascade

    remove_foreign_key :quiz_answers, :quiz_questions
    add_foreign_key :quiz_answers, :quiz_questions, on_delete: :cascade

    remove_foreign_key :quiz_answers, :quiz_alternatives
    add_foreign_key :quiz_answers, :quiz_alternatives, on_delete: :cascade

    remove_foreign_key :quiz_answers, :quiz_form_submissions
    add_foreign_key :quiz_answers, :quiz_form_submissions, on_delete: :cascade
  end
end
