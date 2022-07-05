# frozen_string_literal: true

class Bff::User::EssaysController < Bff::User::BffUserBaseController
 
  def my_essays
    @essay_submission = EssaySubmission.where({ user: current_user }).page(page_param).per_page(per_page_param(10)) 
    pagination = pagination_meta(@essay_submission)
    return render_not_found if pagination[:page] > pagination[:total_pages] 
    render_results({ pagination: pagination ,my_essays:parse_essays})
  end

  private

  STATUS_ICONS = [
    {
      name: "file-text",
      color: "var(--color-info-500)"
    },
    {
      name: "clock",
      color: "var(--color-warning-500)"
    },
    {
      name: "clock",
      color: "var(--color-warning-500)"
    },
    {
      name: "checkmark-circle",
      color: "var(--color-success-500)"
    },
    {
      name: "checkmark-circle",
      color: "var(--color-success-500)"
    },
    {
      name: "close-circle",
      color: "var(--color-error-500)"
    },
    {
      name: "alert-circle",
      color: "var(--color-error-500)"
    },
    {
      name: "clock",
      color: "var(--color-warning-500)"
    },
    {
      name: "checkmark-circle",
      color: "var(--color-success-500)"
    },
  ].freeze

  STATUS_LABELS = [
    {
      theme: "ghost",
      variant: "info"
    },
    {
      theme: "ghost",
      variant: "warning"
    },
    {
      theme: "ghost",
      variant: "warning"
    },
    {
      theme: "ghost",
      variant: "success"
    },
    {
      theme: "ghost",
      variant: "success"
    },
    {
      theme: "ghost",
      variant: "error"
    },
    {
      theme: "ghost",
      variant: "error"
    },
    {
      theme: "ghost",
      variant: "warning"
    },
    {
      theme: "ghost",
      variant: "success"
    },
  ].freeze

  

  def set_essay(essay)
    @essay = essay
  end

  def parse_essays
    @essay_submission.map do |essay|
        set_essay(essay)
      {
        id: essay.token,
        is_cancelled: essay.cancelled?,
        title: essay.permalink.item.name,
        description: parse_description_by_status,
        href: href_by_status,
        status: @essay.status_humanize,
        formatted_status: admin_status_message,
        icon: STATUS_ICONS[@essay.status],
        labels: [label_by_status],
        actions: actions,
        reject_message: essay.uncorrectable_message,
        permalink_slug: essay.permalink.slug
      }
  
    end
  end



  def admin_status_message
    t("essay_submission.admin_status_message.status_#{@essay.status}")
  end

  def label_by_status
    status_label = STATUS_LABELS[@essay.status]
    status_label =  STATUS_LABELS[0] if status_label.nil?  
    status_label['children'] = t("essay_submission.admin_status_message.status_#{@essay.status}")
    status_label
  end

  def parse_description_by_status
    format(t("essay_submission.description.status_#{@essay.status}"), 
             date: @essay.updated_at.strftime('%d/%m/%Y • %H:%M'))
  end

  def href_by_status
    return essay_pending_url if @essay.draft?

    return essay_submission_correct if @essay.corrected_or_recorrected?

    @essay.essay.url
  end

  def essay_pending_url
    ENV["ESSAY_SUBMISSION_PENDING"] % {permalink_slug: @essay.permalink.slug}
  end

  def essay_submission_correct
    ENV["ESSAY_SUBMISSION_CORRECT"] % {id: @essay.id}
  end

  
  def actions
    permalink = @essay.permalink.slug
    actions = {
      SEND: {
        label: "Enviar proposta",
        left_icon_name: "send",
        href: "/app/redacao/enviar?proposta=#{permalink}",
      },
      SEND_AGAIN: {
        label: "Reenviar proposta",
        left_icon_name: "send",
        href: "/app/redacao/enviar?proposta=#{permalink}",
      },
      DRAFT: {
        label: "Ver rascunho",
        left_icon_name: "file-text",
        href: "https://www.mesalva.com/#{permalink}/plano-de-texto/revisao",
      },
      SEE: {
        label: "Ver correção",
        left_icon_name: "checkmark-circle",
        href: "https://www.mesalva.com/enem-e-vestibulares/redacao/correcao/#{@essay.token}",
      },
      ORIGINAL: {
        label: "Ver original",
        left_icon_name: "external-link",
        target: "_blank",
        href: @essay.essay.url
      },
      REJECT: {
        name: "reject",
        label: "Ver o motivo",
        left_icon_name: "alert-circle",
      },
      CANCEL: {
        name: "cancel",
        label: "Cancelar correção",
        left_icon_name: "close-circle",
      },
    }

    if @essay.draft?
      return [actions[:SEND], actions[:DRAFT], actions[:CANCEL]]
    end
    if @essay.corrected?
      return [actions[:SEE], actions[:ORIGINAL] ]
    end 
    if @essay.awaiting_correction?
      return [actions[:ORIGINAL], actions[:CANCEL]];
    end 
    if @essay.corrected?
      return [actions[:SEE], actions[:ORIGINAL]];
    end
    if @essay.awaiting_correction?
      return [actions[:ORIGINAL], actions[:CANCEL]];
    end
    if @essay.cancelled?
      return [actions[:ORIGINAL]];
    end  
    if @essay.uncorrectable?
      return [actions[:REJECT], actions[:SENDAGAIN], actions[:ORIGINAL]];
    end
    return []
  end
end
