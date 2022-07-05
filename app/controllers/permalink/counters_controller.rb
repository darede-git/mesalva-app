# frozen_string_literal: true

require 'me_salva/permalinks/counter'

class Permalink::CountersController < BasePermalinkController
  include Cache
  skip_before_action :expires_now
  before_action :cache_expiration_time
  before_action -> { invalid_permalink unless @permalink }
  before_action :prepare_permalink_counter

  def show
    return render_not_found if ENV['DISABLE_COUNTERS'] == 'true'

    render_permalink_counter \
      if stale?(etag: @permalink.entities.to_json,
                public: true,
                template: false,
                last_modified: @permalink.updated_at)
  end

  private

  def render_permalink_counter
    render json: @permalink_counter,
           serializer: Permalink::CounterSerializer,
           adapter: :attributes
  end

  def prepare_permalink_counter
    @permalink_counter = MeSalva::Permalinks::Counter.new(permalink: @permalink)
  end

  def invalid_permalink
    render_not_found('permalink.invalid_entities')
  end
end
