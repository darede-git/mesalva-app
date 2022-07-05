class AddsEducationSegmentIdToPackages < ActiveRecord::Migration[4.2]
  def change
  	add_column :packages, :education_segment_id, :integer

  	query = 'UPDATE packages
			SET education_segment_id = node_subquery.id
			FROM (
			  SELECT
			    id,
			    slug
			  FROM nodes
			) AS node_subquery
			WHERE packages.education_segment_slug = node_subquery.slug'
		ActiveRecord::Base.connection.execute(query)
  end
end
