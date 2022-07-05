# frozen_string_literal: true

include QueryHelper

class EssaySubmission < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordQueries
  include TokenHelper
  include TextSearchHelper
  include AlgoliaSearch

  before_validation :generate_token, on: :create
  before_create :set_default_attributes
  before_save :subtract_one_essay_credit, if: :discountable_essay_change?
  after_save :transit_to_awaiting_correction, if: :essay?

  STATUS = { pending: 0,
             awaiting_correction: 1,
             correcting: 2,
             corrected: 3,
             delivered: 4,
             cancelled: 5,
             uncorrectable: 6,
             re_correcting: 7,
             re_corrected: 8 }.freeze

  ESSAY_MASTER_SLUG = 'redacao-master'
  CORRECTION_DEADLINE = { default: 10, master: 2 }


  has_many :essay_submission_transitions, autosave: false
  has_many :essay_events
  has_many :comments, as: :commentable
  has_many :essay_submission_grades
  has_many :correction_style_criteria, -> { order(position: :asc, id: :asc) }, \
           through: :essay_submission_grades
  has_many :essay_marks, -> { order(id: :asc) }
  has_many :essay_correction_checks

  accepts_nested_attributes_for :essay_correction_checks, allow_destroy: true
  accepts_nested_attributes_for :essay_marks, allow_destroy: true
  accepts_nested_attributes_for :essay_submission_grades, allow_destroy: true

  belongs_to :permalink
  belongs_to :user
  belongs_to :correction_style
  belongs_to :platform

  mount_base64_uploader :essay, EssayImageUploader
  mount_base64_uploader :corrected_essay, EssayImageUploader

  validates :correction_type,
            inclusion: { in: %w[redacao-padrao
                                redacao-personalizada
                                redacao-b2b] }
  validates :permalink, :user, :correction_style,
            presence: true, allow_blank: false

  validate :validate_uncorrectable_message_presence

  scope :by_user, ->(user) { where user: user }
  scope :active, -> { where active: true }
  scope :by_user_active, lambda { |user, order_by|
    by_user(user).active.order(created_at: order_by)
  }
  scope :by_correction_style, lambda { |correction_style_id|
    (where correction_style_id: correction_style_id)
  }

  scope :by_status, lambda { |status|
    where(status: EssaySubmission.convert_status_key(status.to_sym))
  }

  scope :expired_correcting, lambda {
    where(status: STATUS[:correcting])
      .where('updated_at < ?', (Time.now - 2.hours))
  }

  scope :current_week_by_user, lambda { |user_id|
    where(user_id: user_id)
      .where('created_at >= ?', Time.now.beginning_of_week)
  }

  scope :by_platform, lambda { |filters|
    unless filters['platform_id'].present? || filters['platform_slug'].present?
      return where("platforms.dedicated_essay = false OR platforms.dedicated_essay IS NULL")
               .joins("LEFT JOIN platforms ON platforms.id = essay_submissions.platform_id") unless filters['platform_id'].present? || filters['platform_slug'].present?
    end

    if filters['platform_slug'].present?
      where({ "platforms.slug": filters['platform_slug'] })
        .joins("INNER JOIN platforms ON platforms.id = essay_submissions.platform_id")
    else
      where(platform_id: filters['platform_id'])
    end
  }

  scope :by_platform_unity, lambda { |filters|
    unless filters['platform_unity_id'].present? && filters['platform_unity_slug'].present? && filters['platform_slug'].present?
      return nil
    end

    where("user_platforms.platform_unity_id": filters['platform_unity_id'])
      .joins("INNER JOIN user_platforms ON user_platforms.user_id = essay_submissions.user_id")
  }

  scope :by_item_name, lambda { |filters|
    return nil unless filters['item_name'].present?

    where(snt_sql(["items.name ILIKE ?", "%#{filters['item_name']}%"]))
      .joins("INNER JOIN permalinks p1 ON p1.id = essay_submissions.permalink_id")
      .joins("INNER JOIN items ON items.id = p1.item_id")
  }

  scope :by_node_module, lambda { |filters|
    return nil unless filters['node_module'].present?

    where("node_modules.slug": filters['node_module'])
      .joins("INNER JOIN permalinks p2 ON p2.id = essay_submissions.permalink_id")
      .joins("INNER JOIN node_modules ON node_modules.id = p2.node_module_id")
  }

  scope :by_package, lambda { |filters|
    return nil unless filters['package_id'].present?

    where("accesses.package_id": filters['package_id'])
      .joins("INNER JOIN accesses ON essay_submissions.user_id = accesses.user_id")
  }

  scope :admin_not_filter, lambda { |filters|
    return nil unless filters['admin_signed_in']

    where.not(status: 0, active: false)
  }

  scope :order_by_send_date, lambda { |order_by = 'desc'|
    order(send_date: order_by)
  }

  scope :order_by_deadline_at, lambda { |order_by = 'desc'|
    order(deadline_at: order_by)
  }

  scope :select_filtered, lambda { |filters|
    where(filters.select { |k, _v| k == 'correction_style_id' })
      .where(filters.select { |k, _v| k == 'updated_by_uid' })
      .where(filters.select { |k, _v| k == 'correction_type' })
      .where(filters.select { |k, _v| k == 'user' })
      .where(filters.select { |k, _v| k == 'status' })
      .where(filters.select { |k, _v| k == 'permalink' })
      .by_platform(filters)
      .by_platform_unity(filters)
      .by_item_name(filters)
      .by_node_module(filters)
      .by_package(filters)
      .admin_not_filter(filters)
  }

  scope :by_period, lambda { |start_date, end_date|
    where('created_at >= ? AND created_at <= ?', start_date, end_date)
      .where(platform_id: nil)
  }

  def create_empty_grades
    correction_style = self.correction_style
    correction_style_criteria = correction_style.correction_style_criterias
    correction_style_criteria.map do |criterium|
      EssaySubmissionGrade.create(correction_style_criteria: criterium, essay_submission: self)
    end
  end

  def self.limit_first_essay_by_period(start_date, end_date)
    period_essays = by_period(start_date, end_date)
    period_essays.update_all(active: false)
    period_essays.pluck(:user_id).uniq.each do |user_id|
      period_essays.where(user_id: user_id).first.update(active: true)
    end
  end

  def self.activate_by_period(start_date, end_date)
    period_essays = by_period(start_date, end_date)
    period_essays.update_all(active: true)
  end

  def set_default_attributes
    self.status ||= STATUS[:pending]
    self.correction_type ||= 'redacao-padrao'
  end

  def create_essay_event
    EssayEvent.create!(essay_event_params('essay_submission', self))
    create_intercom_event('essay_submission', user, intercom_params)
  end

  def delayed?
    return created_at < 7.days.ago if default_leadtime?

    created_at < leadtime.days.ago
  end

  def default_leadtime?
    leadtime.nil?
  end

  def leadtime
    correction_style.leadtime
  end

  def state_machine
    @state_machine ||= EssaySubmissionState.new(
      self, transition_class: EssaySubmissionTransition
    )
  end

  def self.transition_class
    EssaySubmissionTransition
  end

  private_class_method :transition_class

  def save_status_with_string(key)
    self.status = STATUS[key.to_sym]
    save!
  end

  def self.convert_status_key(key)
    STATUS[key]
  end

  def status_humanize
    STATUS.key(status)
  end

  def draft?
    status == STATUS[:pending]
  end

  def awaiting_correction?
    status == STATUS[:awaiting_correction]
  end 

  def correcting?
    status == STATUS[:correcting]
  end

  def corrected?
    status == STATUS[:corrected]
  end
  
  def delivered?
    status == STATUS[:delivered]
  end
  def cancelled?
    status == STATUS[:cancelled]
  end

  def uncorrectable?
    status == STATUS[:uncorrectable]
  end
  def re_correcting?
    status == STATUS[:re_correcting]
  end

  def re_corrected?
    status == STATUS[:re_corrected]
  end


  def corrected_or_recorrected?
    corrected? || re_corrected?
  end

  def valuer_uid
    last_event = essay_events.where
                             .not(essay_status: [STATUS[:re_correcting], STATUS[:re_corrected]])
                             .order(:created_at).try(:last)
    last_event&.try(:valuer_uid)
  end

  def self.stats_by_user(user_id)
    stats_for(user_id)
  end

  def self.stats_for(user_id)
    EssaySubmission
      .connection
      .select_all(query(user_id))
      .to_hash
  end

  def grade_final
    return if grades.nil?

    grade_values.reduce(:+)
  end

  def reset_attributes
    update!(feedback: nil, uncorrectable_message: nil, grades: nil,
            updated_by_uid: nil, corrected_essay: nil, rating: nil,
            draft_feedback: nil, appearance: {}, essay_marks: [])
  end

  def update_send_date
    return unless send_date.nil?

    update!(send_date: Time.now)
  end

  def update_deadline
    user_deadline = user_essay_premium? ? CORRECTION_DEADLINE[:master] : CORRECTION_DEADLINE[:default]
    update!(deadline_at: send_date +  user_deadline.days)
  end

  def user_essay_premium?
    user.features.pluck(:slug).include?(ESSAY_MASTER_SLUG)
  end

  def user_uid
    user.uid
  end

  def self.query(user_id)
    <<~SQL
      WITH essays AS
      ( SELECT COUNT(*) AS count
      FROM essay_submissions
      WHERE user_id = #{user_id}
             AND status = 4 )
            SELECT COALESCE(MAX((grades::JSONB ->> 'grade_final')::NUMERIC),0)
          max_grade,
          (SELECT count
           FROM essays)
        FROM essay_submissions
        WHERE user_id = #{user_id}
          AND grades::JSONB ? 'grade_final'
          AND status = #{STATUS[:delivered]}
    SQL
  end

  algoliasearch auto_index: true, disable_indexing: Rails.env.test? do
    attributesForFaceting %w[id]
    attribute :id do
      token
    end
    attribute :created_at do
      created_at.strftime('%a, %e %b %Y %H:%M:%S')
    end
    attribute :user_uid do
      user.uid
    end
    attribute :user_name do
      user.name
    end
    attribute :valuer_uid do
      valuer_uid
    end
    attribute :item_name do
      permalink.item_name
    end
    attribute :correction_style do
      correction_style.name
    end
    attribute :status do
      status_humanize
    end
  end

  private

  def validate_uncorrectable_message_presence
    return true unless status == STATUS[:uncorrectable]

    errors.add(:uncorrectable_message, :validate_uncorrectable_message_presence) unless uncorrectable_message.present?
  end

  def discountable_essay_change?
    essay? && essay_changed? && !free_or_unlimited_credits?
  end

  def subtract_one_essay_credit
    Access.user_active_accesses_order_by_expiring_date(user).each do |access|
      if access.essay_credits.positive?
        access.update(essay_credits: access.essay_credits - 1)
        return true
      end
    end

    errors.add(:base, I18n.t("activerecord.errors.messages.unauthorized_credit"))
    throw(:abort)
  end

  def free_or_unlimited_credits?
    return true unless permalink
    return true if permalink.free_item?
    return true if user_with_unlimited_credits?
  end

  def user_with_unlimited_credits?
    user.accesses
        .map(&:package)
        .pluck(:unlimited_essay_credits)
        .include?(true)
  end

  def grade_values
    grades.except('grade_final').values.compact
  end

  def transit_to_awaiting_correction
    state_machine.transition_to(:awaiting_correction) if status.zero?
  end
end
