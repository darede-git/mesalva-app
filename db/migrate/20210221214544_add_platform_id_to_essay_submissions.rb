class AddPlatformIdToEssaySubmissions < ActiveRecord::Migration[5.2]
  def change
    add_column :essay_submissions, :platform_id, :bigint, nullable: true
    add_foreign_key :essay_submissions, :platforms
  end
end
