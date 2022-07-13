# frozen_string_literal: true

module CommonModelScopes
  extend ActiveSupport::Concern

  included do
    scope :find_or_create, lambda { |data|
      model = where(data).take
      return create(data) if model.nil?

      model
    }

    scope :ms_filters, lambda { |data|
      filter_data = []
      data.each do |key, value|
        if /^like_/.match?(key)
          new_key = key.gsub(/^like_/, '')
          filter_data << sanitize_sql(["#{table.name}.#{new_key} ILIKE ?", "%#{value}%"])
        elsif value.kind_of?(Array)
          filter_data << "#{table.name}.#{key} IN (#{value.join(',')})"
        elsif value.nil? == false
          filter_data << sanitize_sql(["#{table.name}.#{key} = ?", value])
        end
      end
      where(filter_data.join(' AND '))
    }
  end

  def sanitize_sql(sql, **values)
    ActiveRecord::Base.sanitize_sql_array([sql, values])
  end
end
