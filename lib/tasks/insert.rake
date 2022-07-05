
namespace :insert do
  task :materia => :environment do
    csv_row = get_csv_row('materia')
    csv_row.each do |row|
      sleep(ENV['SLEEP_TIME_INSERT_TASK'].to_i.seconds)
      curso_pai = Node.find_by_name(row[0])
      area_pai = curso_pai.children.where(name: row[1]).first
      Node.create!(
        name: row[2],
        parent_id: area_pai.id,
        description: row[5] == '#N/A' ? nil : row [5],
        node_type: 'subject',
        active: true,
        color_hex: color_hex(row[4])
      )
      AlgoliaObjectIndexWorker.perform_async(Node, area_pai.id)
    end
  end

  task :module_new_structure => :environment do
    require 'me_salva/permalinks/builder'
    log = ''
    beginning_slack_message("MÓDULO - NOVA ESTRUTURA")
    csv_content = get_csv_row("module_new_structure")
    csv_content.each_with_index do |row, index|
      begin
        sleep(ENV['SLEEP_TIME_INSERT_TASK'].to_i.seconds)
        permalink = Permalink.find_by_slug(row[8])
        parent_node = permalink.nodes.last
        node_module = NodeModule.create!(
          code: row[0],
          name: row[1],
          description: row[2],
          position: row[9],
          relevancy: row[10],
          nodes: [parent_node]
        )
        MeSalva::Permalinks::Builder.new(entity_id: node_module.id,
                                        entity_class: 'NodeModule'
                                       ).build_subtree_permalinks
        message = success_message(index, row, log)
      rescue => error
        message = error_output(index, row, log, error)
      end
      publish_message(message, log)
    end
  end

  task :modulo => :environment do
    require 'me_salva/permalinks/builder'
    require 'fog'
    beginning_slack_message("MÓDULO")
    log = ''
    csv_row = get_csv_row('modulo')
    csv_row.each_with_index do |row,index|
      begin
        sleep(ENV['SLEEP_TIME_INSERT_TASK'].to_i.seconds)

        if row[3] == 'ES'
          ids = node_es_id(row[4])
        elsif row[3] == 'EM'
          ids = get_ids(row[5], row[6])
        end

        modulo = NodeModule.create!(
          name: row[1],
          node_ids: ids,
          code: row[0],
          description: row[2]
        )

        MeSalva::Permalinks::Builder.new(
          entity_id: modulo.id,
          entity_class: 'NodeModule'
        ).build_subtree_permalinks

        if row[8].present?
          itens = row[8].split(',')
          itens.each do |code|
            item = Item.find_by_slug(code.strip)
            item.node_module_ids = [modulo.id]
            midia = item.medium_ids
            item.medium_ids = []
            item.medium_ids = midia
            item.save
          end
        end

        modulo.nodes.pluck(:id).each do |id|
          AlgoliaObjectIndexWorker.perform_async(Node, id)
        end

        message = success_message(index, row, log)
      rescue => error
        message = error_output(index, row, log, error)
      end
      publish_message(message, log)
    end
    send_log_to_s3('modulo', log)
  end

  task :items => :environment do
    require 'me_salva/permalinks/builder'
    beginning_slack_message("ITENS")
    log = ''
    csv_row = get_csv_row('items')
    csv_row.each_with_index do |row,index|
      begin
        sleep(ENV['SLEEP_TIME_INSERT_TASK'].to_i.seconds)
        next if row[5] == 'ok'
        modulo = NodeModule.find_by_name(row[4])

        if %w(fixation_exercise video text).include?(row[1])
          item = Item.create!(name: row[2],
                              node_module_ids: [modulo.id],
                              free: false,
                              active:true,
                              code: row[0],
                              description: row[3],
                              item_type: row[1])

          MeSalva::Permalinks::Builder.new(entity_id: item.id,
                                          entity_class: 'Item')
                                     .build_subtree_permalinks
        end
        message = success_message(index, row, log)

        AlgoliaObjectIndexWorker.perform_async(NodeModule, modulo.id)
      rescue => error
        message = error_output(index, row, log, error)
      end
      publish_message(message, log)
    end
    send_log_to_s3('items', log)
  end

  task :media => :environment do
    require 'me_salva/permalinks/builder'
    beginning_slack_message("MÍDIAS")
    log = ''
    items_ids = []
    csv_row = get_csv_row('media')
    csv_row.each_with_index do |row,index|
      begin
        sleep(ENV['SLEEP_TIME_INSERT_TASK'].to_i.seconds)
        next if row[12] == 'ok'

        item = Item.where(name: row[0]).last
        if row[1] == "fixation_exercise"
          fixation_exercise(item, row)
        elsif row[1] == "video"
          video(item, row)
        elsif row[1] == "text"
          medium_text_creation(item, row)
        end
        message = success_message(index, row, log)
        items_ids.push(item.id) unless items_ids.include?(item.id)
      rescue => error
        message = error_output(index, row, log, error)
      end
      publish_message(message, log)
    end
    items_ids.each do |item|
      AlgoliaObjectIndexWorker.perform_async(Item, item.id)
    end
    send_log_to_s3('media', log)
  end

  task :media_edit=> :environment do
    csv_row = get_csv_row('media_edit')
    csv_row.each do |row|
      sleep(ENV['SLEEP_TIME_INSERT_TASK'].to_i.seconds)

      medium = Medium.find_by_slug(row[2])
      if row[0] == "fixation_exercise"
        fixation_exercise_edit(medium, row)
      elsif row[0] == "text"
        medium_text_edit(medium, row)
      end
    end
  end

  task :link_entities => :environment do
    csv_content = get_csv_row("link")
    entities_class = csv_content.delete_at(0)
    persist_relationships(csv_content, entities_class)
  end

  task :new_structure => :environment do
    require 'me_salva/permalinks/builder'
    engenharia_course_attr = { name: 'Cursos', ancestry: '1/6', node_type: 'library', active: false }
    engenharia_course = create_or_find_node(engenharia_course_attr)

    create_new_nodes(engenharia_course)

    create_new_library_node_modules
    create_new_library_items
    link_media_by_item_names
  end

  private

  def create_new_nodes(engenharia_course)
    log = ''
    csv_content = get_csv_row("new_structure_node")
    csv_content.delete_at(0)
    csv_content.each_with_index do |row, index|
      begin
        sleep(ENV['SLEEP_TIME_INSERT_TASK'].to_i.seconds)
        node_attr = { name: row[0], description: row[1], node_type: 'subject',
                      slug: row[2], color_hex: '91CCF1',
                      ancestry: self_and_ancestry(engenharia_course), image: row[3] }
        create_or_find_node(node_attr)
        message = success_message(index, row, log)
      rescue => error
        message = error_output(index, row, log, error)
      end
      publish_message(message, log)
    end
    send_log_to_s3('engenharia_nodes', log)
  end

  def create_new_library_node_modules
    log = ''
    csv_content = get_csv_row("new_structure_node_module")
    csv_content.delete_at(0)
    csv_content.each_with_index do |row, index|
      begin
        sleep(ENV['SLEEP_TIME_INSERT_TASK'].to_i.seconds)
        node_module_attr = { name: row[1], slug: row[2], description: row[5],
                             code: row[6], image: row[3] }
        node_module = create_or_find_node_module(find_parent_by_name(Node, row[0]),
                                                 node_module_attr, row[4])
        message = success_message(index, row, log)
      rescue => error
        message = error_output(index, row, log, error)
      end
      publish_message(message, log)
    end
    send_log_to_s3('engenharia_node_modules', log)
  end

  def create_new_library_items
    log = ''
    csv_content = get_csv_row("new_structure_item")
    csv_content.delete_at(0)
    csv_content.each_with_index do |row, index|
      begin
        sleep(ENV['SLEEP_TIME_INSERT_TASK'].to_i.seconds)
        item_attr = { name: row[1], item_type: row[2], code: row[3], slug: row[4] }
        item = create_or_find_item(find_parent_by_name(NodeModule, row[0]), item_attr, row[5])
        message = success_message(index, row, log)
      rescue => error
        message = error_output(index, row, log, error)
      end
      publish_message(message, log)
    end
    send_log_to_s3('items', log)
  end

  def link_media_by_item_names
    log = ''
    csv_content = get_csv_row("new_structure_link")
    entities_classes = csv_content.delete_at(0)
    child_class = entities_classes[0]
    parent_class = entities_classes[1]
    beginning_slack_message(child_class.upcase, "VINCULAÇÃO")
    csv_content.each do |row|
      begin
        sleep(ENV['SLEEP_TIME_INSERT_TASK'].to_i.seconds)
        child_id = row[0]
        parent_id = find_parent_by_name(Item, row[1]).id
        child = find_entity(child_class, child_id)
        add_parent(child, parent_id, parent_class)
        MeSalva::Permalinks::Builder.new(entity_id: parent_id.to_i,
                                    entity_class: parent_class)
                               .build_subtree_permalinks
        message = success_link_message(child_class, child_id, parent_class, parent_id)
      rescue => error
        message = error_link_message(child_class, child_id, parent_class, parent_id, error)
      end
      publish_message(message, log)
    end
    send_log_to_s3('engenharia_links', log)
  end

  def find_parent_by_name(entity_class, entity_name)
    entity_class.where(name: entity_name).order(:id).last
  end

  def build_permalinks(entity)
    MeSalva::Permalinks::Builder.new(entity_id: entity.id,
                                    entity_class: entity.class.name)
                               .build_subtree_permalinks
  end

  def find_node_module_by_row(row)
    return NodeModule.find(row[0]) unless row[0].nil?
    NodeModule.find_by_code(row[1])
  end

  def create_or_find_node(attr)
    node = Node.where(ancestry: attr[:ancestry], name: attr[:name]).last
    return node unless node.nil?
    new_node = Node.create!(attr)
    new_node.update_column(:image, attr[:image])
    build_permalinks(new_node)
    new_node
  end

  def create_or_find_node_module(parent, attr, position)
    node_module = parent.node_modules.where(name: attr[:name]).take
    return node_module unless node_module.nil?
    new_node_module = NodeModule.create!(attr.merge(nodes: [parent]))
    new_node_module.update_column(:image, attr[:image])
    new_node_module.node_node_modules.take.update(position: position)
    build_permalinks(new_node_module)
    new_node_module
  end

  def create_or_find_item(parent, attr, position)
    item = parent.items.where(name: attr[:name]).take
    return item unless item.nil?
    new_item = Item.create!(attr.merge(node_modules: [parent]))
    new_item.node_module_items.take.update(position: position)
    build_permalinks(new_item)
    new_item
  end

  def self_and_ancestry(node)
    [node.ancestry, node.id].join('/')
  end

  def persist_relationships(csv_rows, entities_class)
    child_class = entities_class[0]
    parent_class = entities_class[1]
    beginning_slack_message(child_class.upcase, "VINCULAÇÃO")
    log = ''
    csv_rows.each do |row|
      begin
        sleep(ENV['SLEEP_TIME_INSERT_TASK'].to_i.seconds)
        child_id = row[0]
        parent_id = row[1]
        child = find_entity(child_class, child_id)
        add_parent(child, parent_id, parent_class)
        MeSalva::Permalinks::Builder.new(entity_id: parent_id.to_i,
                                    entity_class: parent_class)
                               .build_subtree_permalinks
        message = success_link_message(child_class, child_id, parent_class, parent_id)
      rescue => error
        message = error_link_message(child_class, child_id, parent_class, parent_id, error)
      end
      publish_message(message, log)
    end
  end

  def class_to_column(class_name)
    return "node_module_ids" if class_name == "NodeModule"
    "#{class_name.downcase}_ids"
  end

  def add_parent(child, parent_id, parent_class)
    column_name = class_to_column(parent_class)
    child.public_send("#{column_name}=", child.public_send(column_name) << parent_id.to_i)
  end

  def find_entity(class_name, id)
    class_name.constantize.find(id.to_i)
  end

  def fixation_exercise(item, row)
    correct = alternative_correct(row[10])

    medium = Medium.create!(name: row[2],
                            medium_text: text(row[4]),
                            item_ids: [item.id],
                            medium_type: 'fixation_exercise',
                            correction: text(row[11]),
                            audit_status: row[15],
                            answers_attributes: [
                              { text: text(row[5]), correct: correct[0] },
                              { text: text(row[6]), correct: correct[1] },
                              { text: text(row[7]), correct: correct[2] },
                              { text: text(row[8]), correct: correct[3] },
                              { text: text(row[9]), correct: correct[4] }
                            ])
    MeSalva::Permalinks::Builder.new(entity_id: medium.id,
                                    entity_class: 'Medium')
                               .build_subtree_permalinks

    medium.items.pluck(:id).each do |id|
      AlgoliaObjectIndexWorker.perform_async(Item, id)
    end
  end

  def fixation_exercise_edit(medium, row)
    medium.medium_text = text(row[3]) unless row[3].nil?
    medium.correction = text(row[10]) unless row[10].nil?

    answers = medium.answers
    answers[0].text = text(row[4]) unless row[4].nil?
    answers[1].text = text(row[5]) unless row[5].nil?
    answers[2].text = text(row[6]) unless row[6].nil?
    answers[3].text = text(row[7]) unless row[7].nil?
    answers[4].text = text(row[8]) unless row[8].nil?
    medium.answers = answers
    medium.save
  end

  def medium_text_edit(medium, row)
    medium.medium_text = text(row[3]) unless row[3].nil?
    medium.save
  end

  def video(item, row)
    medium = Medium.create!(name: row[2],
                            item_ids: [item.id],
                            medium_type: 'video',
                            video_id: row[15] == 'youtube' ? row[3] : "1b04b9bc8e0ddfcaa5abd9fe33234e4d/#{row[3]}",
                            provider: row[15] == 'youtube' ? 'youtube' : 'sambatech',
                            seconds_duration: row[4] == nil ? 0 : row[4].split(':').map { |a| a.to_i }.inject(0) { |a, b| a * 60 + b},
                            code: row[2],
                            active: true)
    MeSalva::Permalinks::Builder.new(entity_id: medium.id, entity_class: 'Medium').build_subtree_permalinks
    medium.items.pluck(:id).each do |id|
      AlgoliaObjectIndexWorker.perform_async(Item, id)
    end
  end

  def medium_text_creation(item, row)
    medium = Medium.create!(name: row[2],
                            item_ids: [item.id],
                            medium_type: 'text',
                            medium_text: text(row[4]),
                            code: row[2],
                            active: true)
    MeSalva::Permalinks::Builder.new(entity_id: medium.id, entity_class: 'Medium').build_subtree_permalinks
    medium.items.pluck(:id).each do |id|
      AlgoliaObjectIndexWorker.perform_async(Item, id)
    end
  end

  def alternative_correct(correct)
    arr_alternative = [false, false, false, false, false]
    arr_alternative.each_with_index do |val, index|
      arr_alternative[index] = true if correct.to_i - 1 == index
    end
  end

  def text(text)
    image = "<p><img style='display: block; margin-left: auto; margin-right: auto;' src='https://cdnqa.mesalva.com/uploads/medium/attachment/#{text.match(/{{(.*?)}}/).to_s.delete("{{").delete("}}")}' alt=''></p>"
    text.gsub(/(?<={{)[^\/]+(?=\}})/, image).delete("{{").delete("}}")
  end

  def color_hex(color)
    return '91ccf1' if color == 'Azul'
    return 'a4c942' if color == 'Verde'
    return 'fad36a' if color == 'Amarelo'
    return 'F1ab6d' if color == 'Laranja'
    return '333333' if color == 'Preto'
    return 'efebe1' if color == 'Bege'
    return 'bca6e6' if color == 'Roxo'
    return 'ed4343'
  end

  def get_ids(materia_name, areas_names)
    ids = []
    areas = areas_names.split('-')
    areas.each do |area|
      n = Node.find_by_name(area)
      next if n.nil?
      n.children.each do |materia|
        m = materia.children.where(name: materia_name).first
        ids << m.id if m
      end
    end
    ids
  end

  def node_es_id(link)
    permalink = Permalink.find_by_slug(link.split('https://mesalva.com/')[1])
    [permalink.node_ids.last]
  end

  def get_csv_row(name)
    require 'open-uri'
    url = "https://s3.amazonaws.com/mesalva-uploads/uploads/csv/#{name}.csv"
    csv_data = open(url)
    CSV.parse(csv_data.read.gsub(/\r/, '').force_encoding("UTF-8"))
  end

  def send_log_to_s3(file_name, log)
    connection = Fog::Storage.new({
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['AMAZON_ACCESS_KEY_ID'],
      :aws_secret_access_key  => ENV['AMAZON_SECRET_ACCESS_KEY']
    })

    time = Time.now.localtime.to_s.split
    directory = connection.directories.get(ENV['S3_BUCKET'])

    file = directory.files.new({
      :key    => "uploads/csv/#{file_name}_errors_#{time[0]}_#{time[1]}.txt",
      :body   => log,
      :public => true
    })
    file.save
  end

  def beginning_slack_message(name, action="INSERÇÃO")
    text = "RELATÓRIO DE #{action} DE #{name} - #{DateTime.now.strftime('%d/%m/%y - %R')}"
    system web_hook_request(text)
  end

  def success_message(index, row, log)
    "Linha #{index+1}: Inserção bem sucedida. Código: #{row[2]}\n"
  end

  def success_link_message(child_class, child_id, parent_class, parent_id)
    "#{child_class} #{child_id} corretamente vinculado a entidade #{parent_class} #{parent_id}"
  end

  def error_output(index, row, log, error)
    error = error_message(error)
    "Linha #{index+1}: Erro codigo #{row[2]}\nErro: #{error}\n\n"
  end

  def error_link_message(child_class, child_id, parent_class, parent_id, error)
    error = error_message(error)
    "Erro ao vincular o #{child_class} #{child_id} a entidade #{parent_class} #{parent_id}"
  end

  def error_message(error)
    error.message.split(',').first
  end

  def web_hook_request(text)
    "/usr/bin/curl -X POST --data-urlencode 'payload={\"channel\": \"#relatório_inserção\", \"username\": \"tchuchucao\", \"text\": \"#{text}\", \"icon_emoji\": \":ghost:\"}' https://hooks.slack.com/services/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"
  end

  def publish_message(message, log)
    message.gsub!(/'/, "`")
    puts message
    log.concat(message)
    system web_hook_request(message)
  end
end
