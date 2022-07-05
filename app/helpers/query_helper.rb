# frozen_string_literal: true

module QueryHelper
  def snt_sql(params)
    ActiveRecord::Base.sanitize_sql_array(params)
  end
end
