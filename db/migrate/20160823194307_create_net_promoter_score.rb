class CreateNetPromoterScore < ActiveRecord::Migration[4.2]
  def change
    create_table :net_promoter_scores do |t|
      t.integer :score
      t.text :reason
      t.references :promotable, polymorphic: true, index: true
    end
  end
end
