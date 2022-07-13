# frozen_string_literal: true

class Bff::User::ContentsController < Bff::User::BffUserBaseController
  before_action :set_medium
  skip_before_action :authenticate_user, only: %w[show_essay show_exercise]

  ESSAY_TEXT_PLAIN_URL = "#{ENV['DEFAULT_URL']}/%{permalink}/plano-de-texto"
  ESSAY_SUBMIT_URL = "#{ENV['DEFAULT_URL']}/app/redacao/enviar?proposta=%{permalink}"

  def show_video
    render_results({ video_id: @medium.video_id })
  end

  def show_essay
    return render_results({ children: [login_title, grid_login_action] }) if current_user.nil?

    render_results({ children: [text_section, video_section,
                                essay_action_buttons, credits_subtitle] })
  end

  def show_text
    render_results({ html: @medium.medium_text })
  end

  def show_rating
    last_rating = MediumRating.where(user_id: current_user.id, medium_id: @medium.id).last
    return render_results({ default_value: 0 }) if last_rating.nil?

    render_results({ default_value: last_rating.value })
  end

  def show_exercise
    render_results({ disabled: !user_has_medium_access?, children: [
      DesignSystem::DangerousHtml.html(@medium.medium_text),
      no_access_button
    ] })
  end

  private

  def credits_subtitle
    credits_subtitle_text = t("bff.user.contents_controler.no_credits_subtitle")
    subtitle = DesignSystem::Button.render(icon_name: "lock",
                                           children: credits_subtitle_text,
                                           variant: "naked",
                                           href: "https://mesalva.com/app/redacao/enviar", disabled: true)
    subtitle unless submit_essay_active?
  end

  def login_title
    DesignSystem::Title.render(children: t("bff.user.contents_controler.login_title"),
                               level: 3,
                               size: :sm)
  end

  def grid_login_action
    DesignSystem::Grid.render(columns: 2, children: [register_button, login_button])
  end

  def login_button
    essay_url = "/redacao/#{@medium.items.first.main_permalink.slug}"
    DesignSystem::Button.render(children: t("bff.user.contents_controler.login_button"),
                                variant: "secondary",
                                href: "https://mesalva.com/app/entrar?path=#{essay_url}")
  end

  def register_button
    essay_url = "/redacao/#{@medium.items.first.main_permalink.slug}"
    DesignSystem::Button.render(children: t("bff.user.contents_controler.register_button"),
                                variant: "primary",
                                href: "https://mesalva.com/app/entrar?path=#{essay_url}")
  end

  def video_section
    return nil if @medium.video_id.blank?

    DesignSystem::Video.from_medium(@medium)
  end

  def text_section
    DesignSystem::DangerousHtml.html(@medium.medium_text)
  end

  def text_plan_active?
    current_user.accesses.any? do |access|
      access.package.features.any? do |feature|
        feature.token == 'text_plan'
      end
    end
  end

  def submit_essay_active?
    current_user.accesses.any? do |access|
      access.essay_credits.positive? || access.package.unlimited_essay_credits
    end
  end

  def essay_action_buttons
    DesignSystem::Grid.render(columns: 2, children: [write_plan_text, send_essay_button])
  end

  def write_plan_text
    permalink_slug = @medium.items.first.main_permalink.slug
    text = t("bff.user.contents_controler.write_plan_text")
    DesignSystem::Button.render(children: text,
                                variant: "naked",
                                disabled: !text_plan_active?,
                                href: format(ESSAY_TEXT_PLAIN_URL,
                                             permalink: permalink_slug))
  end

  def send_essay_button
    permalink_media = @medium.main_permalink.slug
    text = t("bff.user.contents_controler.send_essay")
    DesignSystem::Button.render(children: text,
                                variant: "primary",
                                disabled: !submit_essay_active?,
                                href: format(ESSAY_SUBMIT_URL,
                                             permalink: permalink_media))
  end

  def user_has_medium_access?
    return false if current_user.nil?

    # TODO definir disabled como false apenas se o current_user tem acesso a esta aula
    true
  end

  def no_access_button
    return nil if user_has_medium_access?

    DesignSystem::Button.render(icon_name: "lock",
                                children: t("bff.user.contents_controler.show_exercise.no_access_message"),
                                variant: "naked",
                                href: "https://mesalva.com/app/redacao/enviar", disabled: true)
  end

  def set_medium
    @medium = Medium.find_by_token(params[:token]) # TODO: validar se a pessoa tem acesso a esta aula
  end
end
