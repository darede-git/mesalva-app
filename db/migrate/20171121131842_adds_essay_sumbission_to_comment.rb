class AddsEssaySumbissionToComment < ActiveRecord::Migration[4.2]
  def change
  	add_reference :comments, :essay_submission, index: true, foreign_key: true
  end
end
