# frozen_string_literal: true

class Member < ActiveRecord::Base
  self.abstract_class = true
  include AlgoliaSearch
  include AlgoliaModel

  mount_base64_uploader :image, MemberImageUploader

  algoliasearch index_name: 'Members', \
                auto_index: false, \
                disable_indexing: Rails.env.test?, \
                id: :algolia_id do
    attributesForFaceting %w[group uid]
    attribute :uid, :image_url, :name, :email, :active,
              :provider

    attribute :group do
      model_name.name
    end
    attribute :facebook_uid do
      try(:facebook_uid)
    end
    attribute :google_uid do
      try(:google_uid)
    end
  end
end
