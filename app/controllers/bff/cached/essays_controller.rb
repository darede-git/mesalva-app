# frozen_string_literal: true

class Bff::Cached::EssaysController < Bff::Cached::BffCachedBaseController
  ESSAY_NODE_TOKEN = 'redacao'
  PERMALINK_PREFIX = 'enem-e-vestibulares/redacao'
  ENEM_CORRECTION_STYLE_ID = 1
  before_action :set_year_essays, only: :weekly_essay

  def proposals
    fetcher = -> { { proposals: parsed_proposals } }
    render_cached(fetcher)
  end

  def weekly_essay
    fetcher = -> { { essay: weekly_essays } }
    render_cached(fetcher)
  end

  private

  def parsed_proposals
    @parsed_proposals = []
    categories.each { |category| parse_category(category) }
    @parsed_proposals
  end

  def parse_category(category)
    active_listed_items(category).each do |proposal|
      @parsed_proposals << parse_proposal(category, proposal)
    end
  end

  def active_listed_items(category)
    Item
      .select("items.*, media.slug medium_slug")
      .joins(:media, :node_module_items)
      .where(active: true, listed: true)
      .where({ "node_module_items.node_module_id": category.id, "media.medium_type": "essay" })
      .order(:name)
  end

  def categories
    NodeModule.active.listed.by_node_token(ESSAY_NODE_TOKEN).order(:name)
  end

  def parse_proposal(category, proposal)
    correction_style_id = proposal.options['essay_correction_style_id'] || ENEM_CORRECTION_STYLE_ID
    correction_style_name = CorrectionStyle.find(correction_style_id).name
    medium_slug = proposal.medium_slug
    {
      "name": "#{category.name} | #{proposal.name}",
      "permalink_slug": "#{PERMALINK_PREFIX}/#{category.slug}/#{proposal.slug}/#{medium_slug}",
      "correction_style_id": correction_style_id,
      "correction_style_name": correction_style_name
    }
  end

  def set_year_essays
    @year_essay = MeSalva::Aws::File.read_json("schedules/weekly-essays.json")
  end

  def weekly_essays
    @year_essay.find do |essay|
      essay['startsAt'].to_date <= Date.today && essay['expiresAt'].to_date >= Date.today
    end
  end
end
