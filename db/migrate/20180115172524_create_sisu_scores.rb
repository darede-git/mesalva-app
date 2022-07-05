class CreateSisuScores < ActiveRecord::Migration[4.2]
  def change
    create_table :sisu_scores do |t|
      t.string :initials
      t.string :ies
      t.string :college
      t.string :course
      t.string :grade
      t.string :shift
      t.string :modality
      t.string :semester
      t.string :cnat_weight
      t.string :chum_weight
      t.string :ling_weight
      t.string :mat_weight
      t.string :red_weight
      t.string :cnat_score
      t.string :chum_score
      t.string :ling_score
      t.string :mat_score
      t.string :red_score
      t.string :cnat_avg
      t.string :chum_avg
      t.string :ling_avg
      t.string :mat_avg
      t.string :red_avg
      t.string :passing_score
      t.string :average
      t.string :chances
      t.references :quiz_form_submission, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
