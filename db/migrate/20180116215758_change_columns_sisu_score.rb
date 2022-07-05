class ChangeColumnsSisuScore < ActiveRecord::Migration[4.2]
  def change
    change_column :sisu_scores, :cnat_weight, 'float USING CAST(cnat_weight AS float)'
    change_column :sisu_scores, :chum_weight, 'float USING CAST(chum_weight AS float)'
    change_column :sisu_scores, :ling_weight, 'float USING CAST(ling_weight AS float)'
    change_column :sisu_scores, :mat_weight, 'float USING CAST(mat_weight AS float)'
    change_column :sisu_scores, :red_weight, 'float USING CAST(red_weight AS float)'
    change_column :sisu_scores, :cnat_score, 'float USING CAST(cnat_score AS float)'
    change_column :sisu_scores, :chum_score, 'float USING CAST(chum_score AS float)'
    change_column :sisu_scores, :ling_score, 'float USING CAST(ling_score AS float)'
    change_column :sisu_scores, :mat_score, 'float USING CAST(mat_score AS float)'
    change_column :sisu_scores, :red_score, 'float USING CAST(red_score AS float)'
    change_column :sisu_scores, :cnat_avg, 'float USING CAST(cnat_avg AS float)'
    change_column :sisu_scores, :chum_avg, 'float USING CAST(chum_avg AS float)'
    change_column :sisu_scores, :ling_avg, 'float USING CAST(ling_avg AS float)'
    change_column :sisu_scores, :mat_avg, 'float USING CAST(mat_avg AS float)'
    change_column :sisu_scores, :red_avg, 'float USING CAST(red_avg AS float)'
    change_column :sisu_scores, :passing_score, 'float USING CAST(passing_score AS float)'
    change_column :sisu_scores, :average, 'float USING CAST(average AS float)'

    change_column :sisu_weightings, :cnat_weight, 'float USING CAST(cnat_weight AS float)'
    change_column :sisu_weightings, :chum_weight, 'float USING CAST(chum_weight AS float)'
    change_column :sisu_weightings, :ling_weight, 'float USING CAST(ling_weight AS float)'
    change_column :sisu_weightings, :mat_weight, 'float USING CAST(mat_weight AS float)'
    change_column :sisu_weightings, :red_weight, 'float USING CAST(red_weight AS float)'
  end
end
