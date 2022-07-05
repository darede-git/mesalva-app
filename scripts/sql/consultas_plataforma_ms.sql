-- Todas as redações por UID
SELECT es.*
FROM essay_submissions es
         INNER JOIN users u on es.user_id = u.id
WHERE u.uid = '{uid_do_estudante}';

-- Resolve video_id Fleming quando foram subidos com o projeto errado da samba (projeto do me salva)
UPDATE media
SET updated_at = now(), video_id = REPLACE(video_id, '1b04b9bc8e0ddfcaa5abd9fe33234e4d', '24dd6c96c91396b9674536d9d0fd06cd')
WHERE platform_id = 7 AND video_id LIKE '1b04b9bc8e0ddfcaa5abd9fe33234e4d%';
