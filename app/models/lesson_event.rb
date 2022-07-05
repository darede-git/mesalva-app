class LessonEvent < ActiveRecord::Base
  include CommonModelScopes
  belongs_to :user

  validates_presence_of :user, :node_module_slug

  scope :by_user_module_slug, -> (user, node_module_slug) { where(user_id: user.id, node_module_slug: node_module_slug) }
  scope :prep_test_only, -> { where('submission_token IS NOT NULL') }

  def self.module_events(user, node_module_slug)
    module_events = where(user_id: user.id, node_module_slug: node_module_slug)
    { results: module_events }
  end

  def self.create_item_event(user, events_consumed, permalink_slug)
    events_consumed.each do |event|
      permalink = Permalink.where(slug: "#{permalink_slug}/#{event.first.last}").where('item_id IS NOT NULL').take
      next if permalink.nil?
      item = permalink.item
      node_module = permalink.node_module
      create!(node_module_slug: node_module.slug,
              node_module_token: node_module.token,
              item_slug: item.slug,
              item_token: item.token,
              user_id: user.id)
    end
  end
end
