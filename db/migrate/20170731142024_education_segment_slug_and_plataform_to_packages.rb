class EducationSegmentSlugAndPlataformToPackages < ActiveRecord::Migration[4.2]
  def change
  	add_column :packages, :education_segment_slug, :string
  	add_column :packages, :platform, :string
  	add_index :packages, :education_segment_slug

  	query = 'UPDATE packages
			SET education_segment_slug = node_subquery.slug, platform = \'web\'
			FROM (
			  SELECT
			    id,
			    slug
			  FROM nodes
			) AS node_subquery
			WHERE packages.education_segment_id = node_subquery.id'
		ActiveRecord::Base.connection.execute(query)
  end
end
