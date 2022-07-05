class ChangeAuthorshipType < ActiveRecord::Migration[4.2]
  def change
    change_table :items do |t|
      t.change :updated_by, :string
      t.change :created_by, :string
    end

    change_table :node_modules do |t|
      t.change :updated_by, :string
      t.change :created_by, :string
    end

    change_table :nodes do |t|
      t.change :updated_by, :string
      t.change :created_by, :string
    end

    change_table :media do |t|
      t.change :updated_by, :string
      t.change :created_by, :string
    end
  end
end
