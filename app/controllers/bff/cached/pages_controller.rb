# frozen_string_literal: true

class Bff::Cached::PagesController < Bff::Cached::BffCachedBaseController
  def show
    fetcher = -> do
      @adapter = Bff::Templates::PageContent.new(params[:slug] || params[:token])
      @adapter.fetch_page_content
      @adapter.render
    end
    render_cached(fetcher)
  end

  def show_study_plan
    fetcher = -> do
      @adapter = Bff::Templates::PageContent.new('plano-de-estudos')
      @adapter.fetch_page_content
      @adapter.render['children'].each do |child|
        child['endpoint'] += "/#{params[:page]}" if params[:page] && child['endpoint'].present?
      end
      @adapter.render
    end
    render_cached(fetcher)
  end
end
