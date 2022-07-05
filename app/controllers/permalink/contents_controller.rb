# frozen_string_literal: true

require 'me_salva/permalinks/content'

class Permalink::ContentsController < BasePermalinkController
  include Cache
  skip_before_action :expires_now
  before_action :cache_expiration_time
  before_action :set_permalink
  before_action :set_entities

  def show
    render_permalink(entities: content.entities) \
      if stale?(etag: content.entities.to_json,
                public: true,
                template: false,
                last_modified: content.permalink.updated_at)
  end

  private

  def render_permalink(meta)
    render json: content.permalink,
           serializer: Permalink::PermalinkSerializer,
           meta: meta, status: :ok
  end

  def set_permalink
    return render_not_found('permalink.invalid_entities') \
      unless content.permalink
  end

  def set_entities
    return render_not_found('permalink.invalid_entities') \
      if content.entities.empty?
  end

  def content
    @content ||= ::MeSalva::Permalinks::Content.new(params['slug'])
  end

  def permalink_params
    params.permit(:slug, :answer_id, :event_name, :rating)
  end
end
