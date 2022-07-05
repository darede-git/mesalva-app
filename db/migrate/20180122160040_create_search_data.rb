class CreateSearchData < ActiveRecord::Migration[4.2]
  def change
    create_table :search_data do |t|
      t.string :name
      t.string :link
      t.string :description
      t.string :text
      t.string :attachment
      t.string :entity_type
      t.string :entity
      t.string :permalink_slug
      t.string :education_segment
      t.string :second_level_slug
      t.integer :popularity
      t.integer :node_id
      t.integer :node_module_id
      t.integer :item_id
      t.integer :medium_id
      t.integer :permalink_id
      t.boolean :free

      t.timestamps null: false
    end
    execute 'ALTER TABLE search_data ALTER COLUMN created_at SET DEFAULT now()'
    execute 'ALTER TABLE search_data ALTER COLUMN updated_at SET DEFAULT now()'
    execute <<-SQL
    CREATE OR REPLACE FUNCTION empty(TEXT)
RETURNS bool AS
        $$ SELECT $1 ~ '^[[:space:]]*$' OR $1 IS NULL; $$
        LANGUAGE sql
        IMMUTABLE;
COMMENT ON FUNCTION empty(TEXT)
        IS 'Returns true if TEXT has a length of zero or IS NULL';
    SQL
  end
end
