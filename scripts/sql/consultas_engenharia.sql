-- Todos os nodes do tipo subject (pai de módulo) da engenharia
SELECT n.*
FROM permalinks p
INNER JOIN permalink_nodes pn on p.id = pn.permalink_id
INNER JOIN nodes n on pn.node_id = n.id
WHERE node_module_id IS NULL
AND p.slug LIKE 'engenharia/%'
AND n.node_type = 'subject';
