# frozen_string_literal: true

class ChangeLpSectionsToLpBlocks < ActiveRecord::Migration[5.2]
  def change
    rename_table :lp_sections, :lp_blocks
    add_column :lp_blocks, :type_of, :string, default: "section"
    add_column :lp_blocks, :data, :jsonb, default: {}
    add_column :lp_blocks, :active, :boolean, default: true
    add_column :lp_pages, :active, :boolean, default: true
  end
end
