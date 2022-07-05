# frozen_string_literal: true

class V2::ApplicationSerializer
  include FastJsonapi::ObjectSerializer

  set_key_transform :dash
end
