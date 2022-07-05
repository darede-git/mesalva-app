ActiveRecord::Base.connection.execute('ALTER SEQUENCE quiz_forms_id_seq RESTART WITH 11;')
ActiveRecord::Base.connection.execute('ALTER SEQUENCE quiz_questions_id_seq RESTART WITH 11;')
ActiveRecord::Base.connection.execute('ALTER SEQUENCE quiz_alternatives_id_seq RESTART WITH 1000;')
FactoryBot.create(:enem_answer_grid, user_id: 1)
