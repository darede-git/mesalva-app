module Bff
  module Templates
    class PageContent
      def initialize(slug)
        @slug = slug
      end

      def fetch_page_content
        @page_content = fetch_json("app/#{CGI.escape(@slug)}")
        add_page_content_imports
      end

      def render
        @page_content
      end

      private

      def add_page_content_imports
        return nil if @page_content['children'].nil?

        @page_content['children'] = @page_content['children'].map do |child|
          parse_child(child)
        end
      end

      def parse_child(child)
        if child['import'].blank?
          if child['children'].present? && child['children'].kind_of?(Array)
            child['children'] = child['children'].map do |grand_child|
              parse_child(grand_child)
            end
          end
          return child
        end

        more_content = fetch_json(child['import'])
        child.keys.each do |key|
          more_content[key] = child[key] unless key == 'import'
        end
        more_content.tap { |field| field.delete('import') }

        if more_content['children'].present? && more_content['children'].kind_of?(Array)
          more_content['children'] = more_content['children'].map do |grand_child|
            parse_child(grand_child)
          end
        end
        more_content
      end

      def fetch_json(json_file)
        JSON.parse(MeSalva::Aws::File.read("#{json_file}.json", 'data/'))
      end
    end
  end
end
