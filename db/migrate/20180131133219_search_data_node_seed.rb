class SearchDataNodeSeed < ActiveRecord::Migration[4.2]
  def change
    reversible do |change|
      change.up do
        execute <<-SQL
        INSERT INTO search_data (name, link, description, attachment, 
entity_type, entity, permalink_slug, education_segment, second_level_slug, 
popularity, node_module_id, item_id, permalink_id, free)
SELECT name,
   link,
   description,
   CASE EMPTY(attachment)
     WHEN TRUE THEN ''
     ELSE 'https://cdn.mesalva.com/uploads/'|| entity || '/image/' || attachment
   END AS attachment,
   entity_type,
   entity,
   permalink_slug,
   education_segment,
   second_level_slug,
   popularity,
   node_module_id,
   item_id,
   permalink_id,
   free
 FROM
 (WITH contents AS
  (SELECT p.slug,
   CASE
     WHEN i.id IS NOT NULL THEN 'item'
     WHEN i.id IS NULL
       AND nm.id IS NOT NULL THEN 'node_module'
   END AS entity,
   p.node_module_id AS node_module_id,
   'node_module'::TEXT AS node_module_type,
   nm.name AS node_module_name,
   nm.description AS node_module_description,
   nm.image AS node_module_attachment,
   p.item_id AS item_id,
   i.item_type AS item_type,
   i.free AS free,
   i.name AS item_name,
   i.description AS item_description,
   ''::TEXT AS item_attachment,
   p.id AS permalink_id
FROM permalinks p
LEFT JOIN node_modules nm ON nm.id = p.node_module_id
LEFT JOIN items i ON i.id = p.item_id
WHERE p.slug !~ 'enem-e-vestibulares/maratona-de-estudos|enem-e-vestibulares/introducao-ao-enem-2018|enem-e-vestibulares/operacao-enem-2017|enem-e-vestibulares/revisao-vestibulares-regionais-2017|enem-e-vestibulares/revisao-enem-2017|enem-e-vestibulares/aquece-revisao-enem-2017|enem-e-vestibulares/experimente-o-novo-jeito-de-aprender-enem-e-vestibulares|enem-e-vestibulares/intensivo-expresso-enem-2017|enem-e-vestibulares/maratona-de-estudos-enem-2017|enem-e-vestibulares/matematica-para-enem-e-vestibulares|enem-e-vestibulares/matematica-avancada-para-enem-e-vestibulares|enem-e-vestibulares/redacao-para-enem-e-vestibulares|enem-e-vestibulares/biologia-para-enem-e-vestibulares|enem-e-vestibulares/intensivo-medicina-2017|enem-e-vestibulares/intensivo-2017|enem-e-vestibulares/intensivo-basico-2017|enem-e-vestibulares/extensivo-medicina-2017|enem-e-vestibulares/extensivo-engenharia-2017|enem-e-vestibulares/extensivo-direito-2017|enem-e-vestibulares/extensivo-2017|enem-e-vestibulares/nivelamento-extensivo-2017|enem-e-vestibulares/propostas-de-correcao-de-redacao|enem-e-vestibulares/operacao-enem-2016|enem-e-vestibulares/plano-de-revisao|enem-e-vestibulares/vestibulares-regionais|enem-e-vestibulares/plano-de-estudos-intensivo-expresso-2016|enem-e-vestibulares/plano-de-estudos-intensivo-2016|enem-e-vestibulares/plano-de-estudos-semiextensivo-2016|enem-e-vestibulares/plano-de-estudos-extensivo-2016|enem-e-vestibulares/series-me-salva|enem-e-vestibulares/revisao-vestibular-regionais-2017|enem-e-vestibulares/experimente-o-novo-jeito-de-aprender|enem-e-vestibulares/academia-de-redacao|enem-e-vestibulares/academia-de-matematica'
  AND p.node_module_id IS NOT NULL
  AND p.medium_id IS NULL
)
SELECT CASE entity
            WHEN 'item' THEN item_name
            WHEN 'node_module' THEN node_module_name
        END AS name,
        'https://mesalva.com/' || slug AS link,
        CASE entity
            WHEN 'item' THEN item_description
            WHEN 'node_module' THEN node_module_description
        END AS description,
        CASE entity
            WHEN 'item' THEN item_attachment
            WHEN 'node_module' THEN node_module_attachment
        END AS attachment,
        CASE entity
            WHEN 'item' THEN item_type
            WHEN 'node_module' THEN node_module_type
        END AS entity_type,
        entity,
        (
          select UNNEST(regexp_split_to_array(slug, '/')) LIMIT 1
        ) as education_segment,
        (
          select UNNEST(regexp_split_to_array(slug, '/')) LIMIT 1 OFFSET 1
        ) as second_level_slug,
        slug AS permalink_slug,
        CASE entity
            WHEN 'item' THEN 10
            WHEN 'node_module' THEN 100
        END AS popularity,
        node_module_id,
        item_id,
        permalink_id,
        free
 FROM contents ) data
        SQL
      end
      change.down do
        execute "DELETE from search_data WHERE entity != 'node'"
      end
    end
  end
end
