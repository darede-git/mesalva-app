class CreateIntarrayExtension < ActiveRecord::Migration[4.2]
  def change
    ActiveRecord::Base.connection
      .execute('CREATE EXTENSION IF NOT EXISTS intarray')
  end
end
