# frozen_string_literal: true

module MeSalva
  module Permalinks
    class StreamingLessonsManager
      def initialize(filename)
        @filename = filename
        @rows = CSV.read(open("https://mesalva-uploads.s3.amazonaws.com/uploads/csv/scripts/#{filename}.csv"))
        @header = @rows.slice!(0)

        node_aovivo = Permalink.find_by_slug('enem-e-vestibulares/monitorias').nodes.last
        @ancestry = "#{node_aovivo.ancestry}/#{node_aovivo.id}"

        @categorias = {
          enem: Node.where(ancestry: @ancestry, name: 'Salas por matéria - ENEM').take,
          med: Node.where(ancestry: @ancestry, name: 'Salas por matéria - MED').take
        }
        @result = []
      end

      def reindex_all
        Node.where(ancestry: @ancestry).reindex!
        node_ids = Node.where(ancestry: @ancestry).pluck(:id)
        NodeModule.joins(:node_node_modules).where({ "node_node_modules.node_id": node_ids }).reindex!
        node_module_ids = NodeModule.joins(:node_node_modules).where({ "node_node_modules.node_id": node_ids }).pluck(:id)
        Item.joins(:node_module_items).where({ "node_module_items.node_module_id": node_module_ids }).reindex!
        item_ids = Item.joins(:node_module_items).where({ "node_module_items.node_module_id": node_module_ids }).pluck(:id)
        Medium.joins(:item_media).where({ "item_media.item_id": item_ids }).reindex!
        @salas.values.each do |n|
          n.values.each do |n2|
            n2.rebuild_permalink
          rescue StandardError
            puts "not rebuild"
          end
        end
      end

      def mount_salas
        @salas = {
          enem: {},
          med: {}
        }

        @rows.each do |row|
          sala_nome = row[first_row_index]
          sala_id = row[next_row_index]
          sala_nome = Node.where(id: sala_id).first&.name if sala_nome.blank? && sala_id

          next if sala_nome.blank?

          sala_token = sala_nome.downcase.gsub(' ', '_').gsub('á', 'a').gsub('í', 'i').gsub('ç', 'c').gsub('ã', 'a').gsub('ê', 'e').gsub('ó', 'o').gsub('ú', 'u').gsub('_-_', '_')
          categoria_slug = sala_nome.downcase.include?('med') ? :med : :enem
          categoria = @categorias[categoria_slug]
          sala_ansestry = categoria.ancestry + '/' + categoria.id.to_s

          next unless @salas[categoria_slug][sala_token].nil?

          node_sala = Node.where(ancestry: sala_ansestry, name: sala_nome).take
          if node_sala.nil?
            node_sala = Node.create(name: sala_nome, node_type: 'subject', ancestry: sala_ansestry, color_hex: '333333', active: true, parent_id: categoria.id)
          end
          @salas[categoria_slug][sala_token] = node_sala
        end
      end

      def fix_module_names
        @categorias.values.each do |categoria|
          categoria.children.map do |sala|
            sala.node_modules.map do |nm|
              new_name = nm.name.gsub(/ \[.*/, '')
              if new_name != nm.name
                nm.name = new_name
                nm.save
              end
            end
          end
        end
      end

      def report
        csv = @result.map { |row| row.values.to_csv }.join
        options = { "file_path" => "uploads/csv/scripts/" }
        MeSalva::Aws::File.write("#{@filename}.result.#{DateTime.now}.csv", csv, options)
        @result
      end

      def mount_modules
        @rows.each_with_index do |row, index|
          @row = row
          @script_index = index
          @result[@script_index] = {}
          mount_row
        end
      end

      def debug
        { result: @result, rows: @rows, salas: @salas, categorias: @categorias }
      end

      private

      def lesson_date(row)
        value = row[next_row_index]
        return '2022-05-16' if value.blank?

        value.gsub(%r{(\d{2})/(\d{2})/(\d{4})}, '\3-\2-\1')
      end

      def mount_row
        sala_nome = @row[first_row_index]
        sala_id = @row[next_row_index]
        data_aula = lesson_date(@row)
        hora_aula_inicio = @row[next_row_index] || '16:00'
        hora_aula_fim = @row[next_row_index] || '17:00'
        modulo_nome = @row[next_row_index]
        module_id = @row[next_row_index]
        item_aovivo_nome = @row[next_row_index].sub('Aula - ', '')
        midia_aovivo_nome = @row[next_row_index].sub('Aula - ', '')
        midia_aovivo_token = @row[next_row_index]
        item_lista_nome = @row[next_row_index]
        exercicio_lista_id = @row[next_row_index]

        inicio_nome = "#{data_aula} #{hora_aula_inicio}"
        data_hora_aula_inicio = Time.parse("#{data_aula} #{hora_aula_inicio}") - 3.hours
        data_hora_aula_fim = Time.parse("#{data_aula} #{hora_aula_fim}") - 3.hours

        sala_nome = Node.where(id: sala_id).first&.name if sala_nome.blank? && sala_id

        return if sala_nome.blank?

        sala_token = slugify(sala_nome)
        categoria_slug = sala_nome.downcase.include?('med') ? :med : :enem

        node_sala = @salas[categoria_slug][sala_token]
        puts({ node_sala: node_sala, categoria_slug: categoria_slug, sala_token: sala_token })
        @result[@script_index][:node_sala_id] = node_sala.id

        if module_id
          modulo = NodeModule.find(module_id)
        else
          slug = slugify("#{modulo_nome} [#{inicio_nome}]")
          modulo = NodeModule.joins(:node_node_modules).where({ "node_node_modules.node_id": node_sala.id, slug: slug }).take
          if modulo.nil?
            modulo = NodeModule.create(active: true, name: "#{modulo_nome} [#{inicio_nome}]", node_ids: [node_sala.id])
          end
        end
        @result[@script_index][:modulo_id] = modulo.id

        item_aovivo = Item.joins(:node_module_items).where({ "node_module_items.node_module_id": modulo.id, name: item_aovivo_nome }).take
        if item_aovivo.nil?
          item_aovivo = Item.create(item_type: 'streaming', active: true, name: "#{item_aovivo_nome} [#{inicio_nome}]", streaming_status: 'scheduled', starts_at: data_hora_aula_inicio, ends_at: data_hora_aula_fim)
          item_aovivo.name = item_aovivo_nome
          item_aovivo.node_module_ids = [modulo.id]
          item_aovivo.save
        end

        @result[@script_index][:item_aovivo_id] = item_aovivo.id

        if item_aovivo.media.count.positive?
          medium_aovivo = item_aovivo.media.first
        else
          if midia_aovivo_nome.nil? == false
            midia_aovivo_slug = slugify("#{midia_aovivo_nome} [#{inicio_nome}]")
            medium_aovivo = Medium.find_by_slug(midia_aovivo_slug)
            if medium_aovivo.nil?
              medium_aovivo = Medium.create(medium_type: 'streaming', active: true, name: "#{midia_aovivo_nome} [#{inicio_nome}]", video_id: midia_aovivo_token, provider: 'youtube')
            end

            item_aovivo.permalinks.each { |p| p.delete }
            medium_aovivo.item_ids = [item_aovivo.id]
          end
        end

        @result[@script_index][:medium_aovivo_id] = medium_aovivo.id

        unless item_lista_nome.nil?
          item_lista = Item.joins(:node_module_items).where({ "node_module_items.node_module_id": modulo.id, name: item_lista_nome }).take
          if item_lista.nil?
            item_lista = Item.new(item_type: 'fixation_exercise', active: true, name: "#{item_lista_nome} [#{inicio_nome}]")
            item_lista.save
            item_lista.node_modules = [modulo]
            item_lista.medium_ids = [exercicio_lista_id] if exercicio_lista_id
            item_lista.name = item_lista_nome
            item_lista.save
          end
        end
        @result[@script_index][:item_lista_id] = item_lista.id unless item_lista.nil?
        @row
      end

      def first_row_index
        @row_index = 2
      end

      def next_row_index
        @row_index += 1
      end

      def slugify(str)
        str.mb_chars.downcase.to_s.gsub(/[^0-9a-z_áéíóúãẽĩõũàèìòùäëïöüâêîôûç\s]/, '')
           .gsub(/\s+/, ' ').strip.tr('_', '-')
           .gsub(/\s/, '-').gsub(/[àáâã]/, 'a')
           .gsub(/[éê]/, 'e').gsub(/[íî]/, 'i')
           .gsub(/[óôõ]/, 'o').gsub(/[úûü]/, 'u')
           .gsub(/ç/, 'c')
           .gsub(/-/, '_')
      end
    end
  end
end
