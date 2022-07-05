class AddCurrentWeekSqlFunction < ActiveRecord::Migration[4.2]
  def change
    reversible do |change|
      change.up do
        execute <<-SQL
        CREATE OR REPLACE FUNCTION current_week(val TEXT)
RETURNS TEXT AS
        $body$
        DECLARE
          days_set int := 0;
          val ALIAS FOR $1;

        BEGIN
        IF val = 'finish' THEN
            days_set := 6;
        END IF;

        RETURN(SELECT to_char(cast(date_trunc('week', current_date) AS DATE) + days_set,
               'DD/MM/YYYY'));
        END
        $body$
        LANGUAGE plpgsql
        IMMUTABLE;
COMMENT ON FUNCTION current_week(TEXT)
        IS 'Returns the starting or ending date of the current week, according to options "start" or "finish"';
        SQL
      end
      change.down do
        execute 'DROP FUNCTION current_week(text)'
      end
      end
  end
end
