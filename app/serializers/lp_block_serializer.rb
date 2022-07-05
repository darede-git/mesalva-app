# frozen_string_literal: true

class LpBlockSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :schema, :type_of
end
