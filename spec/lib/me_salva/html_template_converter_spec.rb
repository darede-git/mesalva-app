# frozen_string_literal: true

require 'me_salva/html_template_converter'

describe MeSalva::HtmlTemplateConverter do
  let(:html_template) { '<b style="width: 100%">%<name>s html %<name>s</b>' }

  subject do
    described_class.new(html_template)
  end

  describe '#convert when receive html with %' do
    it 'convert onlhy variables' do
      expect(subject.convert(name: 'Me Salva!'))
        .to eq('<b style="width: 100%">Me Salva! html Me Salva!</b>')
    end
  end
end
