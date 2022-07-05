# frozen_string_literal: true

class V2::PlatformSerializer
  include FastJsonapi::ObjectSerializer

  has_many :platform_unities, serializer: ::V2::PlatformUnitySerializer

  attributes :name, :slug, :theme, :navigation, :panel, :options, :dedicated_essay,
             :cnpj, :mail_invite, :mail_grant_access, :unity_types
end
