# frozen_string_literal: true

class Bff::User::PersonasController < Bff::User::BffUserBaseController
  skip_before_action :authenticate_user, only: :show_persona_panel
  before_action :set_persona

  def show_persona_panel
    set_persona_from_accesses if @persona.nil?

    @adapter = Bff::Templates::PageContent.new("painel/#{@persona.slug}")
    @adapter.fetch_page_content
    render_results(@adapter.render)
  end

  def show_onboarding_steps
    return render_results({ current_step: 0 }) if @persona.nil? || onboarding.value['current_step'] == 0

    return render_results({ current_step: 5, persona_slug: @persona.slug }) if onboarding.value['finished']

    @onboarding_module_token = "primeiros-passos-#{@persona.slug}"
    distinct_events = LessonEvent.where(user_id: current_user.id, node_module_slug: @onboarding_module_token)
                                 .group(:item_slug).count
    @current_step = distinct_events.count + 1
    @current_step = 4 if @current_step > 4

    onboarding.value.merge!({ "current_step" => @current_step, "persona_slug" => @persona.slug })
    onboarding.save

    render_results(onboarding.value.merge(step_slugs))
  end

  def step_slugs
    return {} if @current_step >= 4 || @current_step < 1

    node_module = NodeModule.find_by_token(@onboarding_module_token)
    return {} if node_module.nil?

    items = node_module.items
    {
      step_slug_1: "#{@onboarding_module_token}/#{items[0].slug}",
      step_slug_2: "#{@onboarding_module_token}/#{items[1].slug}",
      step_slug_3: "#{@onboarding_module_token}/#{items[2].slug}"
    }
  end

  def update_persona
    return render_results({ current_step: 0, finished: false }) if @persona.nil?

    onboarding.value['finished'] = params[:finished]
    onboarding.value['accepted'] = params[:accepted]
    onboarding.save

    unless params[:accepted]
      default_persona_slug = @persona.slug.match?(/-med$/) ? 'padrao-med' : 'padrao-enem'
      MeSalva::User::Persona.new(current_user).set_by_slug(default_persona_slug)
    end
  end

  private

  def set_persona_from_accesses
    return @persona = Role.find_by_slug('padrao-enem') unless user_has_med_access?

    @persona = Role.find_by_slug('padrao-med')
    current_user.roles << @persona

    onboarding.update(value: { finished: false, accepted: false, current_step: 0 })
  end

  def user_has_med_access?
    current_user.accesses.any? do |access|
      access.package.label.include?('medicina-2022-1')
    end
  end

  def onboarding
    @onboarding ||= MeSalva::User::Persona.new(current_user).onboarding
  end

  def set_persona
    return nil if current_user.nil?

    @persona = current_user.roles.where(role_type: 'persona').first
  end
end
