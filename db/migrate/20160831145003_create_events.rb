class CreateEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :events do |t|
      t.string :index
      t.string :type
      t.json :event_data

      t.timestamps null: false
    end
  end
end
