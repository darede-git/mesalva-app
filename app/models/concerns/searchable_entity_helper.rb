# frozen_string_literal: true

require 'me_salva/search/searchable_entity_indexer_factory'

module SearchableEntityHelper
  extend ActiveSupport::Concern

  included do
    after_commit :update_search_data, on: :update
    after_commit :destroy_search_data, on: :destroy
    after_commit :create_search_data, on: :create
  end

  def destroy_search_data
    send_lib_callback(:destroy)
  end

  def create_search_data
    send_lib_callback(:create)
  end

  def update_search_data
    send_lib_callback(:update)
  end

  private

  def send_lib_callback(action)
    return nil if ENV['SEARCH_UPDATE_DISABLE'] == 'true'

    search_data = SearchDatum.find_by_entity(self)
    indexer = MeSalva::Search::SearchableEntityIndexer.for(self, search_data)
    indexer.react_to_action(action)
  end
end
