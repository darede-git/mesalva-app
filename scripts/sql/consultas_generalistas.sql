-- Alunos logados no ultimo dia
SELECT COUNT(*) FROM users WHERE last_sign_in_at >=  (now() - INTERVAL '24 hours');
