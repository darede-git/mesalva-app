# frozen_string_literal: true

class User < Member
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :omniauthable
  include Statesman::Adapters::ActiveRecordQueries
  include DeviseTokenAuth::Concerns::User
  include IntercomHelper
  include CrmEvents
  include AuthenticationHelper
  include PasswordResetHelper
  include TextSearchHelper

  has_many :user_transitions, autosave: false

  validates :active, inclusion: { in: [true, false] }
  validates :profile, inclusion: { in: %w[student teacher tutor] },
                      allow_nil: true
  validate :date_validation

  validates_format_of :email, with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z\d\-]+\z/i,
                              allow_nil: true
  validates_format_of :crm_email, with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z\d\-]+\z/i,
                                  allow_nil: true
  validates_format_of :enem_subscription_id, with: /\A[0-9]{12}\z/, allow_nil: true

  before_save :reflect_crm_email, unless: :crm_email?
  after_update :create_crm_user, if: :crm_user?

  has_many :cancellation_quizzes
  has_many :comments, as: :commenter
  has_many :net_promoter_scores, as: :promotable
  has_many :accesses, -> { active.in_range }
  has_many :subscriptions
  has_many :orders
  has_many :user_settings
  has_many :essay_submissions
  has_many :essay_events
  has_many :study_plans
  has_many :favorites
  has_many :rates
  has_many :scholar_records
  has_many :internal_notes, -> { order(created_at: :desc) },
           class_name: 'Comment', as: :commentable
  has_many :instructor_users
  has_many :instructors, through: :instructor_users
  has_many :user_platforms
  has_many :platforms, through: :user_platforms
  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :mentoring
  has_many :user_transitions, autosave: false

  has_many :packages, through: :accesses
  has_many :features, through: :packages

  has_shortened_urls

  has_secure_token :token

  belongs_to :objective
  belongs_to :education_level

  has_one :address, as: :addressable, dependent: :destroy
  has_one :academic_info, dependent: :destroy

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :academic_info
  accepts_nested_attributes_for :net_promoter_scores

  PREMIUM_STATUS = { student_lead: 0,
                     subscriber: 1,
                     unsubscriber: 2,
                     ex_subscriber: 3 }.freeze

  SOCIAL_BIRTH_DATE = { facebook: '%m/%d/%Y', google: '%Y-%m-%d' }.freeze

  scope :by_admin_uid, lambda { |admin_uid|
    where("uid = :admin_uid OR email = :admin_uid", admin_uid: admin_uid)
  }

  def premium
    accesses.count.positive?
  end

  def premium?
    premium
  end

  def not_premium?
    !premium?
  end

  def education_level_name
    education_level&.name
  end

  def objective_name
    objective&.name
  end

  def disable_last_study_plan
    update_active_to(false)
  end

  def reenable_last_study_plan
    update_active_to(true)
  end

  def crm_user?
    saved_changes[:crm_email].present? && saved_changes[:crm_email][0].nil? && !Rails.env.test?
  end

  def crm_email?
    crm_email.present?
  end

  def update_active_to(status)
    study_plans&.last&.update(active: status)
  end

  def disable_last_scholar_record
    scholar_records.last&.update(active: false)
  end

  def change_objective?
    previous_changes.include?('objective_id')
  end

  def reflect_crm_email
    self.crm_email = email
  end

  def trusted_provider?
    %w[email].include?(provider)
  end

  def create_crm_user
    create_intercom_user(self, subscriber: PREMIUM_STATUS[:student_lead])

    PersistCrmEventWorker.perform_async(crm_event_params('sign_up', self))
    CrmRdstationSignupEventWorker.perform_async(uid)
  end

  def phone
    return nil unless [phone_area, phone_number].all?

    "(#{phone_area})#{phone_number}"
  end

  def state_machine
    @state_machine ||= UserState.new(self, transition_class: UserTransition)
  end

  def save_status_with_string(key)
    self.premium_status = PREMIUM_STATUS[key.to_sym]
    save!
  end

  class << self
    def from_omniauth(auth_hash)
      create_new_user(auth_hash) unless find_user(auth_hash)
      update_user_info(auth_hash)
    end

    private

    def auth_hash_info(auth_hash)
      auth_hash['info']
    end

    def update_user_info(hash)
      @user if update_user_data(hash)
    rescue ActiveRecord::RecordNotUnique => e
      NewRelic::Agent.notice_error(@exception, message: e)
      @user.email = nil
      @user
    end

    def update_user_data(hash)
      @user.email ||= hash['email']
      @user.name ||= auth_hash_info(hash)['name']
      @user.gender ||= valid_gender(hash)
      @user.facebook_uid ||= hash['uid'] if hash['provider'] == 'facebook'
      @user.google_uid ||= hash['uid'] if hash['provider'] == 'google'
      @user.apple_uid ||= hash['uid'] if hash['provider'] == 'apple'
      date = auth_hash_info(hash)['birth_date']
      @user.birth_date ||= social_birth_date(hash, date) if date
      @user.save
    end

    def valid_gender(auth_hash)
      return 'Masculino' if auth_hash_info(auth_hash)['gender'] == 'male'

      'Feminino' if auth_hash_info(auth_hash)['gender'] == 'female'
    end

    def create_new_user(auth_hash)
      @user = create(uid: auth_hash['uid'], provider: auth_hash['provider'])
    end

    def find_user(auth_hash)
      @user = User.public_send("find_by_#{auth_hash['provider']}_uid",
                               auth_hash['uid'])
      return @user if @user

      @user = find_by_email(auth_hash['email']) if auth_hash['email']
    end

    def social_birth_date(hash, date)
      DateTime.strptime(date, SOCIAL_BIRTH_DATE[hash['provider'].to_sym])
    end
  end

  def package_labels
    labels = []
    packages.pluck(:label).each do |package_labels|
      labels = labels.concat(package_labels)
    end
    labels.uniq
  end

  def settings
    user_settings = {}
    UserSetting.where(user_id: id).map do |setting|
      key = setting.key
      value = setting.value
      user_settings[key] = value
    end
    user_settings
  end

  private

  def date_validation
    return if birth_date.nil? || MeSalva::DateHelper.valid_date?(birth_date)

    errors.add(:birth_date, I18n.t('errors.models.user.invalid_birth_date'))
  end
end
