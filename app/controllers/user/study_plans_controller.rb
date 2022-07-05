# frozen_string_literal: true

require 'me_salva/study_plan/structure'

class User::StudyPlansController < ApplicationController
  before_action -> { authenticate(%w[user]) }
  after_action :update_pagination_headers, only: :show

  before_action :set_study_plan, only: :update
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  before_action :set_last_study_plan, only: :show
  before_action :set_structure, only: :create

  def show
    if @study_plan
      render json: paginated_results, status: :ok
    else
      render_not_found
    end
  end

  def create
    if @structure.valid?
      StudyPlanStructureWorker.perform_async(@attrs.to_json)
      render_no_content
    else
      render_unprocessable_entity(@structure.errors)
    end
  end

  def update
    return render_unprocessable_entity unless valid_ownership

    if @study_plan.update(study_plan_params)
      render_no_content
    else
      render_unprocessable_entity(@study_plan.errors)
    end
  end

  private

  def valid_ownership
    current_user.id == @study_plan.user.id
  end

  def paginated_results
    serialize(@study_plan,
                 include: [:study_plan_node_modules],
                 meta: study_plan_meta,
                 serializer: 'StudyPlan::StudyPlan')
  end

  def set_study_plan
    @study_plan = StudyPlan.find(params[:id])
  end

  def study_plan_params
    params.permit(:active)
  end

  def set_last_study_plan
    @model = StudyPlan.active
                      .order('created_at DESC')
                      .find_by_user_id(current_user.id)

    return unless @model

    study_plan_struct
  end

  def set_structure
    params.permit!

    @attrs = { user_id: current_user.id,
               shifts: shifts,
               end_date: params[:end_date],
               subject_ids: subject_ids,
               keep_completed_modules: keep_completed_modules? }
    @structure = MeSalva::StudyPlan::Structure.new(@attrs)
  end

  def shifts
    return [{}] unless params[:shifts]

    params[:shifts].map(&:to_hash)
  end

  def subject_ids
    return [] unless params[:subject_ids]

    params[:subject_ids].map(&:to_i)
  end

  def keep_completed_modules?
    return true if params[:keep_completed_modules].nil?

    params[:keep_completed_modules] == true
  end

  def study_plan_meta
    { 'modules-count' => @study_plan.node_modules_count,
      'offset' => @study_plan.offset,
      'limit' => @study_plan.limit,
      'total-pages' => total_pages,
      'completed-modules-count' => @study_plan.completed_node_modules_count,
      'current-week-completed-modules-count' => current_week_completed_count }
  end

  def current_week_completed_modules
    @study_plan.current_week_completed_modules
  end

  def current_week_completed_count
    current_week_completed_modules.count
  end

  def limited(data)
    pagination_for(data[:relationships][:'study-plan-node-modules'][:data])
  end

  def pagination_for(hash)
    hash.reverse! if hash.first[:id] > hash.second[:id]
    hash[page_offset..page_limit - 1]
  end

  def page_offset
    @page = params[:page].to_i
    return @model.offset if @page.zero? || @page == 1

    return history_page_offset if backward_pagination?

    @model.offset + ((@page - 1) * @model.limit)
  end

  def history_page_offset
    offset = @model.offset - (@model.limit * @page.abs)
    return offset unless offset.negative?

    0
  end

  def page_limit
    offset = @model.offset - (@model.limit * @page.abs)
    return @model.limit unless first_completed_page?(offset)

    offset + @study_plan.limit
  end

  def first_completed_page?(offset)
    offset.negative? && backward_pagination?
  end

  def backward_pagination?
    params[:page].to_i.negative?
  end

  def update_pagination_headers
    return unless @study_plan

    response.headers['Page'] = @page
    response.headers['Links'] = links
  end

  # rubocop:disable Metrics/AbcSize
  def links
    hash = { 'self' => request.url }
    hash['first'] = url_for(first_page)
    hash['prev'] = url_for(prev_page) if prev_page >= first_page
    hash['next'] = url_for(next_page) if next_page <= last_page
    hash['last'] = url_for(last_page)
    hash
  end

  # rubocop:enable Metrics/AbcSize

  def total_pages
    return 1 if @study_plan.limit.zero?

    (@study_plan.node_modules_count / @study_plan.limit.to_f).ceil
  end

  def first_page
    return 1 if @study_plan.offset.zero? || @study_plan.limit.zero?

    pages = ((@study_plan.offset - 1) / @study_plan.limit.to_f).ceil
    return - pages if @page.negative?

    pages
  end

  def prev_page
    return -1 if @page == 1

    @page - 1
  end

  def next_page
    return 2 if @page.zero?

    @page + 1
  end

  def last_page
    return 1 if @study_plan.limit.zero?

    modules_ahead = @study_plan.node_modules_count - @study_plan.offset
    (modules_ahead / @study_plan.limit.to_f).ceil
  end

  def url_for(page)
    "#{request.base_url + request.path}?page=#{page}"
  end

  def study_plan_struct
    @study_plan = OpenStruct.new(@model.attributes)
    @study_plan.offset = @model.offset
    @study_plan.limit = @model.limit
    @study_plan.node_modules_count = @model.node_modules_count
    @study_plan.current_week_completed_modules = @model
                                                   .current_week_completed_modules
    @study_plan.completed_node_modules_count = @model
                                                 .completed_node_modules_count
    study_plan_relations
  end

  def study_plan_relations
    @study_plan.study_plan_node_modules = StudyPlanNodeModule.by_study_plan(
      @model.id,
      page_offset,
      page_limit
    )
    @study_plan.study_plan_node_module_ids = @study_plan.study_plan_node_modules
                                                        .pluck(:id)
  end
end
