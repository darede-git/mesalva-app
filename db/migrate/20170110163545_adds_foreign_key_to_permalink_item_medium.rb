class AddsForeignKeyToPermalinkItemMedium < ActiveRecord::Migration[4.2]
  def change
    Permalink.connection.execute("
              ALTER TABLE public.permalinks
              ADD CONSTRAINT permalinks_fk FOREIGN KEY(
                  item_id,
                  medium_id)
              REFERENCES public.item_media(
                  item_id,
                  medium_id)
              ON DELETE CASCADE
              ON UPDATE NO ACTION
              NOT DEFERRABLE;")
  end
end
