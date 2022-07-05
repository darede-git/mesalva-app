# frozen_string_literal: true

module MeSalva
  class HtmlTemplateConverter
    def initialize(template)
      @template = template
    end

    def convert(**params)
      parsed = template_without_percents % params
      parsed.gsub('__PERCENT__', '%')
    end

    private

    def template_without_percents
      @template.gsub(/%([\w\s"';])/, '__PERCENT__\1')
    end
  end
end
