class RenameEssayMeasurerToValuer < ActiveRecord::Migration[4.2]
  def change
    rename_column :essay_events, :measurer_uid, :valuer_uid
  end
end
