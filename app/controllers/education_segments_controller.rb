# frozen_string_literal: true

class EducationSegmentsController < ApplicationController
  include Cache
  skip_before_action :expires_now
  before_action :cache_expiration_time
  before_action :set_nodes, only: :index
  before_action :set_education_segment, only: :area_subjects
  before_action :set_area_subjects, only: :area_subjects

  def index
    return render_not_found if @nodes.empty?

    render_entities(@nodes, :education_segments)
  end

  def area_subjects
    return render_not_found if @education_segment.nil?

    render_entities(@area_subjects, :area_subjects)
  end

  private

  def render_entities(entities, entities_type)
    send("render_#{entities_type}") \
      if stale?(etag: cache_tag(entities),
                public: true,
                template: false,
                last_modified: last_update_for(entities))
  end

  def render_education_segments
    render json: @nodes, each_serializer: EducationSegmentSerializer
  end

  def render_area_subjects
    render json: @area_subjects,
           each_serializer: EducationSegment::AreaSubjectSerializer
  end

  def set_education_segment
    @education_segment = Node.education_segment_by_slug(
      params[:education_segment_slug]
    )
  end

  def set_area_subjects
    return if @education_segment.nil?

    @area_subjects = @education_segment
                     .descendants
                     .where('node_type = ?', 'area_subject')
                     .order(:name)
  end

  def set_nodes
    @nodes = Node.education_segments
  end

  def filter_key
    params[:education_segment_slug] || 'education_segments'
  end

  def cache_tag(entities)
    { filter_key => entities }.to_json
  end
end
