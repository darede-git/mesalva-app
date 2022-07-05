class AddsForeignKeyToPermalinkNodeModuleItem < ActiveRecord::Migration[4.2]
  def change
    Permalink.connection.execute("
      ALTER TABLE public.permalinks
      ADD CONSTRAINT permalinks_fk1 FOREIGN KEY (node_module_id, item_id)
      REFERENCES public.node_module_items(node_module_id, item_id)
      ON DELETE CASCADE
      ON UPDATE NO ACTION
      NOT DEFERRABLE;")
  end
end
