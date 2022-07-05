# frozen_string_literal: true

require 'active_record/connection_adapters/postgresql_adapter'

module ActiveRecord
  module ConnectionAdapters
    class PostgreSQLAdapter
      # Resets the sequence of a table's primary key to the maximum value.
      def reset_pk_sequence!(table, pk = nil, sequence = nil) #:nodoc:
        return if pk || sequence
        default_pk, default_sequence = pk_and_sequence_for(table)

        pk ||= default_pk
        sequence ||= default_sequence

        if @logger && pk && !sequence
          @logger.warn "#{table} has primary key #{pk} with no default seq"
        end

        seq = quote_table_name(sequence)
        select_value <<~SQL
          SELECT setval(#{regclass(seq)},\
          #{bigint(table, seq, pk)}, #{max?(table, pk)})
        SQL
      end

      private

      def bigint(table, seq, pk)
        return max_value_for(table, pk) if max?(table, pk)
        min_value(seq)
      end

      def max?(table, pk)
        max_value_for(table, pk).present?
      end

      def max_value_for(table, pk)
        select_value("SELECT MAX(#{quote_column_name pk}) \
FROM #{quote_table_name(table)}")
      end

      def regclass(seq)
        quote(seq)
      end

      def min_value(seq)
        if postgresql_version >= 100_000
          select_value("SELECT seqmin FROM pg_sequence \
WHERE seqrelid = #{quote(seq)}::regclass")
        else
          select_value("SELECT min_value FROM #{seq}")
        end
      end
    end
  end
end
