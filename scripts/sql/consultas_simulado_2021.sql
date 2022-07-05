-- Simuladão 2021 - Módulo
SELECT * FROM node_modules WHERE slug IN ('1-simuladao-enem-2021');

-- Simuladão 2021 - Itens
SELECT i.*
FROM items i
         INNER JOIN node_module_items nmi ON nmi.item_id = i.id
WHERE nmi.node_module_id = 9029 ORDER BY nmi.position;

-- Atualiza cache dos permalinks
UPDATE permalinks SET updated_at = now() WHERE node_module_id = 9029;

-- Módulos dos principais simulados dos últimos anos
SELECT * FROM node_modules WHERE slug IN ('3-simuladao-enem-2020', '1-simuladao-enem-2021', '1-simulado-2020');
