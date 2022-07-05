# frozen_string_literal: true

module TextSearchHelper
  FILTER_TABLES = %w[Node NodeModule Package Item Medium].freeze

  DINAMIC_FILTER = { ANY_FILTER_FIELDS: %w[id image created_at updated_at
                                           updated_by downloadable active old_id
                                           instructor_id platform_id relevancy position
                                           created_by instructor_type options ancestry info
                                           video old_package_id og_description color_hex
                                           streaming_status chat_token attachment video_id
                                           provider placeholder audit_status iugu_plan_id
                                           iugu_plan_identifier pagarme_plan_id package_id
                                           play_store_product_id app_store_product_id user_id
                                           education_segment_id unlimited_essay_credits
                                           max_pending_essay free payment_proof].freeze,
                     ADMIN_FILTER_FIELDS: %w[id image created_at updated_at downloadable
                                             active old_id instructor_id color_hex relevancy
                                             position instructor_type info video old_package_id
                                             og_description streaming_status chat_token
                                             attachment provider placeholder audit_status
                                             iugu_plan_id iugu_plan_identifier pagarme_plan_id
                                             play_store_product_id app_store_product_id
                                             education_segment_id unlimited_essay_credits
                                             max_pending_essayfree payment_proof] }.freeze

  private

  def filter_data
    @record = @record.attributes.reject! do |key, _value|
      DINAMIC_FILTER[@wich_filter].include?(key)
    end.merge(entity: @entity.downcase, permalink_slug: @permalink_slug)
  end

  def accessible_by
    @wich_filter.to_s.split('_').first.downcase
  end

  def entity_plus_id
    { eid: Base64.encode64("#{@entity}-#{@record.id}").tr("\=", "~ç") }
  end

  def wich_filter
    FILTER_TABLES.include?(@entity) ? :ANY_FILTER_FIELDS : :ADMIN_FILTER_FIELDS
  end

  def permalink_slug
    %w[Node NodeModule Item Medium].include?(@entity) ? @record.permalinks.last&.slug : nil
  end
end
