# frozen_string_literal: true

class Bff::Cached::CourseClassesController < Bff::Cached::BffCachedBaseController
  SUBJECT_NODE_TOKEN = 'todas-as-materias'

  def show_course_class
    fetcher = -> do
      @adapter = Bff::Templates::CoursePages::CoursePageContent.new(params[:slug])
      @adapter.fetch_summary
      @adapter.fetch_page(params[:page])
      @adapter.render
    end
    render_cached(fetcher)
  end
end
