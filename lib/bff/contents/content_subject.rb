module Bff
  module Contents
    class ContentSubject
      def self.simplified_name(name)
        name.gsub(/(Interdisciplinar|Ciências da|Ciências) /, '')
            .gsub('Língua Portuguesa', 'Português')
            .gsub('Conteúdos não listados', 'Especiais')
            .gsub('Educação', 'Ed.')
            .gsub(',', '')
            .strip
      end

      def self.simplified_slug(slug)
        slugify(slug).gsub(/(ciencias-da-|ciencias-|-codigos|-e-suas-tecnologias|interdisciplinar-)/, '')
      end

      def self.label_variant(name)
        return 'medicina' if name == 'Enem e Vestibulares'

        simplified_slug(name) || 'matematica'
      end

      private

      def self.slugify(str)
        str.downcase.gsub(/ /, '-').gsub(/\s/, '-')
           .gsub(/[àáâã]/, 'a')
           .gsub(/[éê]/, 'e').gsub(/[íî]/, 'i')
           .gsub(/[óôõ]/, 'o').gsub(/[úûü]/, 'u')
      end
    end
  end
end
