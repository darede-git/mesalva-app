-- Scripts para gerar a lista de tabelas relacionadas com a tabela de usuários, este script deve ser usado para atualizar
-- o comando db:production:lite no arquivo lib/tasks/db.rake



-- Lista todas as tabelas que tem relação direta com a tabela users (mesmo que não seja pelo campo user_id)
SELECT main_table.table_name, related_table.table_name related_table_name
FROM information_schema.table_constraints AS main_table
         JOIN information_schema.key_column_usage AS relations ON main_table.constraint_name = relations.constraint_name AND main_table.table_schema = relations.table_schema
         JOIN information_schema.constraint_column_usage AS related_table ON related_table.constraint_name = main_table.constraint_name AND related_table.table_schema = main_table.table_schema
WHERE main_table.constraint_type = 'FOREIGN KEY' AND related_table.table_name='users';




-- Lista todas as tabelas que tem relação direta ou indireta com a tabela users, informando quais são as relações desta tabela até chegar a tabela de users
WITH user_tables AS (SELECT main_table.table_name, related_table.table_name related_table_name
                     FROM information_schema.table_constraints AS main_table
                              JOIN information_schema.key_column_usage AS relations ON main_table.constraint_name = relations.constraint_name AND main_table.table_schema = relations.table_schema
                              JOIN information_schema.constraint_column_usage AS related_table ON related_table.constraint_name = main_table.constraint_name AND related_table.table_schema = main_table.table_schema
                     WHERE main_table.constraint_type = 'FOREIGN KEY' AND related_table.table_name='users'),
     second_level_user_tables AS (SELECT main_table.table_name, related_table.table_name related_table_name
                                  FROM information_schema.table_constraints AS main_table
                                           JOIN information_schema.key_column_usage AS relations ON main_table.constraint_name = relations.constraint_name AND main_table.table_schema = relations.table_schema
                                           JOIN information_schema.constraint_column_usage AS related_table ON related_table.constraint_name = main_table.constraint_name AND related_table.table_schema = main_table.table_schema
                                  WHERE main_table.constraint_type = 'FOREIGN KEY' AND related_table.table_name IN (SELECT table_name FROM user_tables)),
     third_level_user_tables AS (SELECT main_table.table_name, related_table.table_name related_table_name
                                 FROM information_schema.table_constraints AS main_table
                                          JOIN information_schema.key_column_usage AS relations ON main_table.constraint_name = relations.constraint_name AND main_table.table_schema = relations.table_schema
                                          JOIN information_schema.constraint_column_usage AS related_table ON related_table.constraint_name = main_table.constraint_name AND related_table.table_schema = main_table.table_schema
                                 WHERE main_table.constraint_type = 'FOREIGN KEY' AND related_table.table_name IN (SELECT table_name FROM second_level_user_tables)),
     all_levels_user_tables AS (SELECT * FROM user_tables UNION SELECT * FROM second_level_user_tables UNION SELECT * FROM third_level_user_tables)
SELECT table_name, array_agg(related_table_name) related_tables
FROM all_levels_user_tables
GROUP BY table_name;

