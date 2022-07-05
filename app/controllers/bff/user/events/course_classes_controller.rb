# frozen_string_literal: true

class Bff::User::Events::CourseClassesController < Bff::User::BffUserBaseController
  before_action :set_adapter
  before_action :validate_course_access, only: %w[index_course_class_events create_course_event destroy_course_event]

  def index
    @adapter.fetch_summary
    @adapter.fetch_page(params[:page])
    render_results({ checked_events: @adapter.user_events(current_user) })
  end

  def create
    @adapter.save_event(current_user, params[:id])
    render_no_content
  end

  def destroy
    @adapter.destroy_event(current_user, params[:id])
    render_no_content
  end

  private

  def set_adapter
    @adapter = Bff::Templates::CoursePages::CoursePageEvents.new(params[:slug])
  end

  def validate_course_access
    payment_required_message unless current_user.package_labels.include?(params[:slug])
  end
end
