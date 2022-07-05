class EssayCorrectionStyleFixer
  def initialize(permalink_slug)
    @node_redacao = Permalink.find_by_slug(permalink_slug).nodes.last
    @report = []
  end

  def fix_all
    @node_redacao.node_modules.each { |instituicao_module | fix_module(instituicao_module) }
    @report
  end

  private

  def fix_module(node_module)
    @item_ids = []
    @medium_ids = []

    set_correction_style_options(node_module.options['essay_correction_style_id'])

    @report << "Módulo #{node_module.name}, correction_style: #{@correction_style.name}"
    node_module.items.each { |item| get_item_medium_ids(item) }
    update_items_options
    update_media_options
  end

  def get_item_medium_ids(item)
    return nil unless item.item_type == 'essay'

    @item_ids << item.id
    item.media.each do |medium|
      next unless medium.medium_type == 'essay'

      @report << "  - Item #{item.id}, Mídia #{medium.name}: #{medium.options}"
      @medium_ids << medium.id
    end
  end

  def update_items_options
    Item.where(id: @item_ids).update(options: essay_options)
  end

  def update_media_options
    Medium.where(id: @medium_ids).update(options: essay_options)
  end

  def essay_options
    { essay_correction_style_id: @correction_style.id }
  end

  def set_correction_style_options(correction_style_id = 1)
    @correction_style = CorrectionStyle.find(correction_style_id)
  end
end

EssayCorrectionStyleFixer.new('enem-e-vestibulares/redacao').fix_all
