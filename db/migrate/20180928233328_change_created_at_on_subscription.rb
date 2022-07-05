class ChangeCreatedAtOnSubscription < ActiveRecord::Migration[4.2]
  def change
    query = 'UPDATE subscriptions SET created_at = now(), updated_at = now()'
  	ActiveRecord::Base.connection.execute(query)

    change_column_null(:subscriptions, :created_at, false)
    change_column_null(:subscriptions, :updated_at, false)
  end
end
