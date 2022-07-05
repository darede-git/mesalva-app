class UserCounterMigration
  def initialize(limit = 500)
    @limit = limit
    @users = {}
  end

  def run(max = '61525de4996ba1000b8e58af')
    last_id = ActiveRecord::Base.connection.execute("SELECT value FROM temporary.configs WHERE key = 'user_counter_id'").first['value'].to_i
    while last_id > max do
      last_id = page(last_id)
    end
  end

  def page(last_id)
    insert_values = []
    UserCounterDocument.where('id < ?', [last_id]).order('id DESC').limit(@limit).each do |row|
      user = user_by_token(row.user_token)
      insert_values << "(#{user.id}, '#{row.period_type}', '#{row.period}', #{row.video}, #{row.text}, #{row.exercise}, #{row.public_document}, #{row.essay}, #{row.book}, now(), now())"
    end
    ActiveRecord::Base.connection.execute("INSERT INTO user_counts (user_id, period_type, period, video, text, exercise, public_document, essay, book, created_at, updated_at) VALUES #{insert_values.join(',')};")
  end

  def user_by_token(token)
    @users[token] |= User.find_by_token(token)
  end
end
