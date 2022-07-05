# frozen_string_literal: true

module AlgoliaIndex
  def update_algolia_index(entity)
    AlgoliaObjectIndexWorker.perform_async(entity.class, entity.id)
  end

  def algolia_attributes?
    attr = %w[uid image name email active]
    (params.keys & attr).any?
  end
end
