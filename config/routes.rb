# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  roles = %w[admin user teacher]
  roles.each do |role|
    mount_devise_token_auth_for role.capitalize,
                                at: role,
                                skip: %i[omniauth_callbacks invitations],
                                controllers: {
                                  sessions: "#{role}/sessions",
                                  registrations: "#{role}/registrations",
                                  passwords: "#{role}/passwords"
                                }
  end

  devise_for :admins, path: 'admin', only: [:invitations],
                      controllers: { invitations: 'admin/invitations' }

  devise_for :teachers, path: 'teacher', only: [:invitations],
                        controllers: { invitations: 'teacher/invitations' }

  devise_scope :user do
    post '/user/:provider/callback', to: 'user/sessions#create'
    post '/user/sign_in/:platform', to: 'user/sessions#cross_platform'
    get '/user/prep_test_overviews', to: 'user/prep_test_overviews#index'
    get '/user/prep_test_details', to: 'user/prep_test_details#index'
  end
  devise_scope :admin do
    post '/admin/impersonations', to: 'admin/impersonations#create'
    mount Coverband::Reporters::Web.new, at: 'admin/prod_coverage' if Rails.env == 'production'
  end

  resources :accesses,                     only: %i[index create update],
                                           module: 'user'
  resources :answer_grids,                 only: :index
  resources :bookshop_gift,                only: %i[index create]
  resources :bookshop_gift_packages,       only: :index
  resources :campaign_events,              only: :create
  resources :cancellation_quizzes,         only: :create
  resources :categories,                   only: %i[index show]
  resources :checkouts,                    only: :create
  resources :comments,                     only: %i[index create update]
  resources :correction_styles,            only: :index
  resources :course_structure_summaries,   except: [:show]
  resources :course_structure_summaries,   only: [:show], param: :slug
  resources :credit_cards,                 only: [:create]
  resources :crm_events,                   only: :create
  resources :discounts,                    only: %i[create update show]
  resources :education_levels,             only: %i[index update destroy]
  resources :enem_scores,                  except: %i[new edit]
  resources :forms,                        only: :index
  resources :images,                       only: %i[create destroy]
  resources :internal_notes,               except: [:show], param: :token
  resources :items,                        only: %i[create update destroy]
  resources :instructors,                  only: :create
  resources :media,                        only: %i[create update destroy]
  resources :media,                        only: :show, param: :slug
  resources :node_modules,                 only: %i[create update destroy]
  resources :nodes,                        only: %i[create update destroy]
  resources :notification_events,          only: %i[create update destroy]
  resources :notifications,                only: %i[index show destroy]
  resources :objectives,                   only: %i[index update destroy]
  resources :orders,                       only: %i[index show create update]
  resources :platforms,                    only: %i[show update], param: :platform_slug
  resources :platforms,                    only: %i[index create]
  resources :postbacks,                    only: :create
  resources :prep_tests,                   only: :show, param: :permalink_slug
  resources :prep_test_events,             only: %i[index create]
  resources :prep_test_events,             only: :show, param: :submission_token
  resources :public_document_events,       only: %i[create update destroy]
  resources :rates,                        only: :create
  resources :refunds,                      only: :update, param: :order_id
  resources :scholar_records,              only: %i[index create]
  resources :schools,                      only: [:show]
  resources :sisu_satisfactions,           only: [:create]
  resources :shortener_urls,               only: %i[index create]
  resources :shortener_urls,               only: %i[show], param: :token
  resources :testimonials,                 except: [:show]
  resources :unsubscribes,                 only: :update, param: :subscription_id
  resources :user_referrals,               only: :index
  resources :lp_pages,                     param: :slug
  resources :contents,                     only: :show, param: :token
  resources :platform_unities,             param: :id
  resources :user_platforms
  resources :lp_blocks
  resources :content_teachers,             param: :slug
  resources :permission_roles
  resources :roles,                        param: :slug
  resources :mentorings
  resources :system_settings,              param: :key
  resources :student_loans,                only: :create
  resources :user_settings,                only: %i[index show destroy update], param: :key
  resources :tangible_products

  resources :faqs, only: %i[create update destroy index] do
    resources :questions, only: %i[update destroy show create]
  end

  namespace :quiz do
    resources :forms, except: %i[edit new]
    resources :questions, except: %i[edit new]
    resources :alternatives, except: %i[edit new]
    resources :form_submissions, except: %i[edit new update destroy]
    resources :answers, except: %i[edit new]
  end

  namespace :bff do
    namespace :user do
      get 'study_plans', to: 'study_plans#show'
      get 'study_plans/:page', to: 'study_plans#show'
      get 'submitted_prep_test_exercise', to: 'exercises#submitted_prep_test_exercise'
      get 'profiles/full', to: 'profiles#full'
      get 'essays', to: 'essays#my_essays'
      get 'personas/onboarding_steps', to: 'personas#show_onboarding_steps'
      put 'personas', to: 'personas#update_persona'
      get 'personas/panel', to: 'personas#show_persona_panel'

      get 'contents/video/:token', to: 'contents#show_video'
      get 'contents/text/:token', to: 'contents#show_text'
      get 'contents/essay/:token', to: 'contents#show_essay'
      get 'contents/rating/:token', to: 'contents#show_rating'
      get 'contents/exercise/:token', to: 'contents#show_exercise'

      namespace :events do
        get '/rating/:token', to: 'contents#show_medium_rating'
        post '/rating/:token', to: 'contents#create_medium_rating'
        post '/exercises/:token', to: 'contents#create_exercise_event'
        get '/sidebar_events/:token', to: 'contents#index_sidebar_events'

        get '/course_classes/:slug(/:page)', to: 'course_classes#index'
        post '/course_classes/:slug(/:page)', to: 'course_classes#create'
        delete '/course_classes/:slug(/:page)', to: 'course_classes#destroy'
        get '/study_plans', to: 'study_plans#index'
        post '/study_plans', to: 'study_plans#create'
        delete '/study_plans', to: 'study_plans#destroy'
      end
    end

    namespace :cached do
      get '/prep_tests/weekly', to: 'prep_tests#show_weekly'
      get '/contents/materias', to: 'contents#enem_subjects'

      get '/essays/proposals', to: 'essays#proposals'
      get '/essays/weekly_essay', to: 'essays#weekly_essay'
      get '/essays/live_classes', to: 'essays_live_classes#live_class'
      get '/essays/weekly_essay', to: 'essays#weekly_essay'

      get '/pages/conteudos/:slug', to: 'contents#dynamic_content'
      get '/pages/exercicio/:slug', to: 'contents#dynamic_content'
      get '/pages/aula/:slug', to: 'contents#dynamic_content'
      get '/pages/video/:slug', to: 'contents#dynamic_content'
      get '/pages/redacao/:slug', to: 'contents#dynamic_content'
      get '/pages/texto/:slug', to: 'contents#dynamic_content'
      get '/pages/plano-de-estudos', to: 'pages#show_study_plan'
      get '/pages/turmas/:slug', to: 'course_classes#show_course_class'
      get '/pages/turmas/:slug/:page', to: 'course_classes#show_course_class'

      get '/pages/*token', to: 'pages#show'

      get '/live_classes', to:'live_classes#weekly'
    end

    namespace :admin do
      get '/contents/:token', to: 'contents#show'
      put '/contents/:token', to: 'contents#update'
      delete '/users/:uid', to: 'users#anonymize_user'
      put '/orders',  to: 'orders#update_price_paid'

    end
  end

  get '/permissions/by_role/:role_slug', to: 'permissions#by_role'
  get '/permissions/:context/:action_name', to: 'permissions#show'
  put '/permissions/:context/:action_name', to: 'permissions#update'
  post '/permissions/:context/:action_name', to: 'permissions#create'
  delete '/permissions/:context/:action_name', to: 'permissions#destroy'
  get '/permissions/:context', to: 'permissions#index'
  get '/permissions', to: 'permissions#index'

  post '/roles/:role_slug/permissions/:permission_id', to: 'permission_roles#grant_permission'
  delete '/roles/:role_slug/permissions/:permission_id', to: 'permission_roles#remove_permission'
  resources :roles do
    resources :permissions
  end

  namespace :platform do
    namespace :user do
      get '/accesses', to: 'accesses#index'
    end
  end


  resources :essay_submissions, except: %i[new edit destroy] do
    resources :essay_submissions, module: 'comment', path: 'comments',
                                  param: :token, only: %i[create update]
  end

  namespace :user do
    get 'feature_events/next' => 'feature_events#show'
    get 'accesses/full' => 'accesses#full'
    get 'study_plans' => 'study_plans#show'
    post '/email_change/confirm', to: 'email_change#confirm'
    resources :email_change, only: :create
    resources :study_plans, only: %i[update create]
    resources :study_plan_node_modules, only: :update
    resources :feature_events, only: %i[index create destroy]
    namespace :dashboards do
      get '/' => 'evolution#index'
      get '/evolution' => 'evolution#index'
      get '/test_repository' => 'test_repository#index'
      get '/test_repository/:submission_token' => 'test_repository#show'
    end
    resources :user_platforms, only: :index
    get '/user_platforms/me' => 'user_platforms#me'
    resources :credit_cards, only: %i[index show create]

    post '/medium_ratings' => 'medium_ratings#create'
    get '/medium_ratings/:medium_slug' => 'medium_ratings#show'

    get '/mentorings' => 'mentorings#index'

    get '/settings' => 'user_settings#index'
    get '/settings/:key' => 'user_settings#show'
    put '/settings/:key' => 'user_settings#upsert'

    get '/permissions', to: 'permissions#index'
    get '/permissions/:context', to: 'permissions#by_context'
    get '/permissions/:context/:action_name', to: 'permissions#show'
  end

  namespace :admin do
    get '/', to: 'profiles#index'
  end

  namespace :sisu do
    resources :institutes, only: :index
    resources :counters, only: :index
    resources :courses, only: :show, param: :uf
    resources :user_scores, only: :create
  end

  post 'platform_vouchers/create_many' => 'platform_vouchers#create_many'
  put "platform_vouchers/rescue", to: 'platform_vouchers#rescue'

  post '/searches' => 'searches#filtered_search'
  get 'permalink_accesses/*slug' => 'permalink/accesses#show'
  get 'permalink_counters/*slug' => 'permalink/counters#show'
  get 'permalink_contents/*slug' => 'permalink/contents#show'
  put 'permalink_canonical/*slug' => 'permalink/canonical#update'
  get 'permalink_suggestions/*slug' => 'permalink/suggestions#index'
  get 'permalink_exercise_lists/*slug' => 'permalink/exercise_lists#show'
  get 'items/streamings' => 'items#streaming_index'

  get 'media/*permalink_slug/comments' => 'comment/media#index'
  post 'media/*permalink_slug/comments' => 'comment/media#create'
  put 'media/*permalink_slug/comments/:token' => 'comment/media#update'
  get 'media/by_id/:id' => 'media#show_by_id'

  scope '/events', module: 'event' do
    get 'permalink/*slug' => 'permalink#show'

    namespace :user do
      get 'last_modules' => 'last_modules#show'
      get 'study_plan' => 'study_plan#show'
    end
  end

  post 'events/permalink/*slug' => 'events#create'

  get 'education_segments' => 'education_segments#index'
  get 'education_segments/:education_segment_slug/area_subjects' =>
      'education_segments#area_subjects'

  put 'essay_submissions/verify',to: 'essay_submissions#verify'

  get 'quiz/forms/:form_id/form_submissions' =>
      'quiz/form_submissions#last_user_submission'

  post 'redeem' => 'discounts#redeem'

  post '/discounts_campaign/carnaval', to: 'discounts_campaign/carnaval#create'
  post '/campaign/voucher', to: 'campaign/voucher#create'

  post '/media/mass_creation', to: 'media#mass_creation'

  get 'testimonials/:education_segment_slug' => 'testimonials#show'

  get 'instructors/is_instructor' => 'instructors#is_instructor'
  get 'instructors/students' => 'instructors#students'
  get 'instructors/student/:student_uid' => 'instructors#student'
  get 'instructors/student/studied_material/:student_uid' => 'instructors#student_watched_and_read_material'
  get 'instructors/student/exercises/:student_uid' => 'instructors#student_exercises'

  get 'scholar_records/disable' => 'scholar_records#disable'

  get 'reset_password/' => 'reset_passwords#reset'

  put 'partner_accesses/', to: 'partner_accesses#register'

  put 'orders/pre_approved_status', to: 'orders#pre_approved_status'
  put 'orders/:id/reprocess', to: 'orders#reprocess'

  get 'lp_blocks/:type_of', to: 'lp_blocks#show'


  roles.each do |role|
    put "#{role}/profiles", to: "#{role}/profiles#update"
    get "#{role}/profiles", to: "#{role}/profiles#show"
  end

  post 'subscriptions/revoke_subscription' => 'subscriptions#revoke_subscription'
  post 'postbacks/webhook_event_from_revenuecat' => 'postbacks#revenuecat'
  post 'postbacks/rdstation/:trigger' => 'postbacks#rdstation'
  post 'postbacks/typeform' => 'postbacks#typeform'
  get 'postbacks/health' => 'postbacks#health'

  get 'campaign_events/count_sequence/:event1/:event2' => 'campaign_events#count_sequence'
  get 'campaign_events/:campaign_name/:event_name' => 'campaign_events#show_event'

  get 'short/:id' => "shortener/shortened_urls#show"

  get 'packages/filter' => 'packages#filter'
  put 'packages/:slug/bookshop_gift' => 'packages#update_bookshop_gift'
  resources :packages,                     only: %i[index create]
  resources :packages,                     only: %i[show update], param: :slug
  get 'packages/:slug/features' => 'packages#features'
  
  ActiveAdmin.routes(self)

  namespace :panel do
    resources :packages, only: :update
  end

  mount Sidekiq::Web => '/admin/sidekiq'
end
