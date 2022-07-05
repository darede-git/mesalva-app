# frozen_string_literal: true

class Bff::Cached::ContentsController < Bff::Cached::BffCachedBaseController
  SUBJECT_NODE_TOKEN = 'todas-as-materias'

  def dynamic_content
    fetcher = -> do
      entity_type = request.path.gsub(/.*pages\//, '').gsub(/\/.*/, '')
      Bff::Contents::ContentPageAdapter.render_page(params[:slug], entity_type, params[:contexto])
    end
    render_cached(fetcher)
  end

  def enem_subjects
    fetcher = -> do
      content = Node.find_by_token(SUBJECT_NODE_TOKEN)
      adapter = Bff::Contents::Sections::ContentSectionLibraryAdapter.new(content)
      adapter.only_list
      { children: adapter.list }
    end
    render_cached(fetcher)
  end
end
