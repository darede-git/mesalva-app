class AddModalityColumnsToSisuScores < ActiveRecord::Migration[5.2]
  def change
    add_column :sisu_scores, :trans, :boolean, default: false
    add_column :sisu_scores, :indigena, :boolean, default: false
    add_column :sisu_scores, :deficiencia, :boolean, default: false
    add_column :sisu_scores, :publica, :boolean, default: false
    add_column :sisu_scores, :carente, :boolean, default: false
    add_column :sisu_scores, :afro, :boolean, default: false
    add_column :sisu_scores, :allowed, :boolean, default: false
  end
end
