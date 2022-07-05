class AddInstructorToNodeModule < ActiveRecord::Migration[4.2]
  def change
    change_table :node_modules do |t|
      t.references :instructor, polymorphic: true, index: true
    end
  end
end
