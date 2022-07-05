# frozen_string_literal: true

class AlgoliaObjectIndexWorker
  include Sidekiq::Worker

  def perform(klass, id)
    @klass = klass.constantize
    @klass.index_objects @klass.where(id: id)
  end
end
