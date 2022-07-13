# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_06_29_185835) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "intarray"
  enable_extension "plpgsql"

  create_table "academic_infos", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "agenda"
    t.string "current_school"
    t.string "current_school_courses"
    t.string "desired_courses"
    t.string "school_appliances"
    t.string "school_appliance_this_year"
    t.string "favorite_school_subjects"
    t.string "difficult_learning_subjects"
    t.string "current_academic_activities"
    t.string "next_academic_activities"
    t.index ["user_id"], name: "index_academic_infos_on_user_id"
  end

  create_table "accesses", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "order_id"
    t.integer "package_id"
    t.datetime "starts_at"
    t.datetime "expires_at"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "remaining_days"
    t.string "created_by"
    t.boolean "gift", default: false
    t.integer "essay_credits"
    t.bigint "platform_id"
    t.integer "private_class_credits", default: 0
    t.index ["active"], name: "index_accesses_on_active"
    t.index ["expires_at"], name: "index_accesses_on_expires_at"
    t.index ["order_id"], name: "index_accesses_on_order_id"
    t.index ["package_id"], name: "index_accesses_on_package_id"
    t.index ["platform_id"], name: "index_accesses_on_platform_id"
    t.index ["starts_at"], name: "index_accesses_on_starts_at"
    t.index ["user_id"], name: "index_accesses_on_user_id"
  end

  create_table "addresses", id: :serial, force: :cascade do |t|
    t.string "street"
    t.integer "street_number"
    t.string "street_detail"
    t.string "neighborhood"
    t.string "city"
    t.string "zip_code"
    t.string "state"
    t.string "country"
    t.string "area_code"
    t.string "phone_number"
    t.string "addressable_type"
    t.integer "addressable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address_type", default: "billing"
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id"
  end

  create_table "admins", id: :serial, force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date "birth_date"
    t.text "description"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.integer "invited_by_id"
    t.integer "invitations_count", default: 0
    t.boolean "active", default: true, null: false
    t.string "role"
    t.index ["confirmed_at"], name: "index_admins_on_confirmed_at"
    t.index ["email"], name: "index_admins_on_email"
    t.index ["invitation_token"], name: "index_admins_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_admins_on_invitations_count"
    t.index ["invited_by_id"], name: "index_admins_on_invited_by_id"
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_admins_on_uid_and_provider", unique: true
  end

  create_table "answers", id: :serial, force: :cascade do |t|
    t.text "text"
    t.text "explanation"
    t.boolean "active"
    t.boolean "correct"
    t.integer "medium_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medium_id"], name: "index_answers_on_medium_id"
  end

  create_table "app_store_transactions", id: :serial, force: :cascade do |t|
    t.string "transaction_id"
    t.integer "order_payment_id"
    t.json "metadata"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.index ["order_payment_id"], name: "index_app_store_transactions_on_order_payment_id"
  end

  create_table "bookshop_gift_packages", force: :cascade do |t|
    t.boolean "active"
    t.string "bookshop_link"
    t.bigint "package_id"
    t.datetime "notified_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "need_coupon", default: false
    t.index ["package_id"], name: "index_bookshop_gift_packages_on_package_id"
  end

  create_table "bookshop_gifts", force: :cascade do |t|
    t.string "coupon"
    t.bigint "bookshop_gift_package_id"
    t.boolean "coupon_available", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "pending_notified_at"
    t.bigint "order_id"
    t.datetime "avaliable_notified_at"
    t.index ["bookshop_gift_package_id"], name: "index_bookshop_gifts_on_bookshop_gift_package_id"
  end

  create_table "campaign_events", force: :cascade do |t|
    t.integer "user_id"
    t.integer "invited_by"
    t.string "campaign_name"
    t.string "event_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "campaign_name", "event_name"], name: "index_campaign_events_user_id_campaign_name_event_name", unique: true
  end

  create_table "cancellation_quizzes", id: :serial, force: :cascade do |t|
    t.integer "order_id"
    t.jsonb "quiz"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["order_id"], name: "index_cancellation_quizzes_on_order_id", unique: true
  end

  create_table "canonical_uris", id: :serial, force: :cascade do |t|
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_canonical_uris_on_slug"
  end

  create_table "colleges", id: :serial, force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_colleges_on_name", unique: true
  end

  create_table "colleges_majors", id: false, force: :cascade do |t|
    t.integer "college_id", null: false
    t.integer "major_id", null: false
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.string "commenter_type"
    t.integer "commenter_id"
    t.text "text"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
    t.string "commentable_type"
    t.integer "commentable_id"
    t.index ["active", "commentable_id", "commentable_type"], name: "index_comments_on_medium"
    t.index ["commenter_type", "commenter_id"], name: "index_comments_on_commenter_type_and_commenter_id"
    t.index ["token"], name: "index_comments_on_token", unique: true
  end

  create_table "complementary_packages", force: :cascade do |t|
    t.bigint "package_id"
    t.bigint "child_package_id"
    t.integer "position"
    t.index ["child_package_id"], name: "index_complementary_packages_on_child_package_id"
    t.index ["package_id"], name: "index_complementary_packages_on_package_id"
  end

  create_table "content_teacher_items", force: :cascade do |t|
    t.bigint "content_teacher_id"
    t.bigint "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_teacher_id"], name: "index_content_teacher_items_on_content_teacher_id"
    t.index ["item_id"], name: "index_content_teacher_items_on_item_id"
  end

  create_table "content_teachers", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "image"
    t.string "description"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar"
    t.string "email"
    t.boolean "active", default: true
  end

  create_table "correction_style_criteria", force: :cascade do |t|
    t.string "name"
    t.float "values", default: [], array: true
    t.bigint "correction_style_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "max_grade", default: [], array: true
    t.string "description"
    t.integer "position"
    t.string "video_id"
    t.index ["correction_style_id"], name: "index_correction_style_criteria_on_correction_style_id"
  end

  create_table "correction_style_criteria_checks", force: :cascade do |t|
    t.string "name"
    t.bigint "correction_style_criteria_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["correction_style_criteria_id"], name: "correction_style_criteria_checks_on_correction_style_criteria"
  end

  create_table "correction_styles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "leadtime", default: 10
    t.boolean "active", default: true
    t.index ["active"], name: "index_correction_styles_on_active"
  end

  create_table "course_structure_summaries", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.boolean "active"
    t.boolean "listed", default: true
    t.boolean "highlighted", default: false
    t.integer "position", default: 1
    t.boolean "is_single_template"
    t.integer "per_page"
    t.string "selling_banner_name"
    t.string "selling_banner_slug"
    t.string "selling_banner_background_color"
    t.string "selling_banner_background_image"
    t.string "selling_banner_price_subtitle"
    t.string "selling_banner_base_price"
    t.string "selling_banner_checkout_button_label"
    t.string "selling_banner_video"
    t.string "selling_banner_infos", array: true
    t.string "selling_banner_package_slug"
    t.string "events_title"
    t.json "events_contents"
    t.string "panel_highlights_image"
    t.string "panel_highlights_color"
    t.string "panel_highlights_name"
    t.string "panel_highlights_button_text"
    t.string "panel_highlights_premium_button_text"
    t.string "essay_text"
    t.string "essay_permalink"
    t.boolean "description_card_hide"
    t.string "description_card_title"
    t.string "description_card_image"
    t.string "description_card_text"
    t.string "description_card_cta_href"
    t.string "description_card_cta_text"
    t.string "description_card_cta_premium_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "selling_banner_checkout_link"
  end

  create_table "crm_events", id: :serial, force: :cascade do |t|
    t.string "event_name"
    t.integer "user_id"
    t.string "user_email"
    t.string "user_name"
    t.string "user_objective"
    t.boolean "user_premium"
    t.string "education_segment"
    t.decimal "order_price"
    t.string "order_payment_type"
    t.string "location"
    t.string "client"
    t.string "user_agent"
    t.string "device"
    t.datetime "created_at", null: false
    t.integer "user_objective_id"
    t.integer "order_id"
    t.string "campaign_view_name"
    t.string "error_message"
    t.string "package_name"
    t.string "package_slug"
    t.string "ip_address"
    t.jsonb "utm"
  end

  create_table "discounts", id: :serial, force: :cascade do |t|
    t.datetime "starts_at"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "token"
    t.integer "percentual"
    t.string "code"
    t.text "description"
    t.string "created_by"
    t.string "updated_by"
    t.string "packages", array: true
    t.string "upsell_packages", array: true
    t.integer "user_id"
    t.boolean "only_customer", default: false
    t.index ["code"], name: "index_discounts_on_code"
    t.index ["packages"], name: "index_discounts_on_packages"
    t.index ["token"], name: "index_discounts_on_token", unique: true
    t.index ["upsell_packages"], name: "index_discounts_on_upsell_packages"
    t.index ["user_id"], name: "index_discounts_on_user_id"
  end

  create_table "education_levels", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["position"], name: "index_education_levels_on_position"
  end

  create_table "enem_answer_grids", id: :serial, force: :cascade do |t|
    t.string "exam"
    t.string "language"
    t.string "color"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quiz_form_submission_id"
    t.integer "year", default: 2017
    t.index ["quiz_form_submission_id"], name: "index_enem_answer_grids_on_quiz_form_submission_id"
    t.index ["user_id"], name: "index_enem_answer_grids_on_user_id"
  end

  create_table "enem_answers", id: :serial, force: :cascade do |t|
    t.integer "quiz_question_id"
    t.string "value"
    t.string "correct_value"
    t.integer "quiz_alternative_id"
    t.boolean "correct"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quiz_form_submission_id"
    t.integer "enem_answer_grid_id"
    t.index ["enem_answer_grid_id"], name: "index_enem_answers_on_enem_answer_grid_id"
    t.index ["quiz_alternative_id"], name: "index_enem_answers_on_quiz_alternative_id"
    t.index ["quiz_form_submission_id"], name: "index_enem_answers_on_quiz_form_submission_id"
    t.index ["quiz_question_id"], name: "index_enem_answers_on_quiz_question_id"
  end

  create_table "essay_correction_checks", force: :cascade do |t|
    t.float "checked", array: true
    t.bigint "correction_style_criteria_check_id"
    t.bigint "essay_submission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["correction_style_criteria_check_id"], name: "essay_correction_checks_on_correction_style_criteria_check_id"
    t.index ["essay_submission_id"], name: "index_essay_correction_checks_on_essay_submission_id"
  end

  create_table "essay_events", id: :serial, force: :cascade do |t|
    t.string "event_name"
    t.integer "essay_submission_id"
    t.integer "user_id"
    t.string "user_name"
    t.string "user_email"
    t.string "correction_style"
    t.string "essay_status"
    t.string "permalink"
    t.jsonb "grades"
    t.string "valuer_uid"
    t.text "feedback"
    t.boolean "delayed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_uid"
    t.string "correction_type", default: "redacao-padrao"
    t.string "uncorrectable_message"
    t.index ["essay_submission_id"], name: "index_essay_events_on_essay_submission_id"
  end

  create_table "essay_marks", force: :cascade do |t|
    t.text "description"
    t.string "mark_type"
    t.jsonb "coordinate"
    t.bigint "essay_submission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["essay_submission_id"], name: "index_essay_marks_on_essay_submission_id"
  end

  create_table "essay_submission_grades", force: :cascade do |t|
    t.bigint "essay_submission_id"
    t.bigint "correction_style_criteria_id"
    t.decimal "grade"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["correction_style_criteria_id"], name: "index_essay_submission_grades_on_correction_style_criteria_id"
    t.index ["essay_submission_id"], name: "index_essay_submission_grades_on_essay_submission_id"
  end

  create_table "essay_submission_transitions", id: :serial, force: :cascade do |t|
    t.string "to_state", null: false
    t.text "metadata", default: "{}"
    t.integer "sort_key", null: false
    t.integer "essay_submission_id", null: false
    t.boolean "most_recent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["essay_submission_id", "most_recent"], name: "index_essay_submission_transitions_parent_most_recent", unique: true, where: "most_recent"
    t.index ["essay_submission_id", "sort_key"], name: "index_essay_submission_transitions_parent_sort", unique: true
  end

  create_table "essay_submissions", id: :serial, force: :cascade do |t|
    t.integer "permalink_id"
    t.integer "user_id"
    t.integer "correction_style_id"
    t.string "essay"
    t.string "corrected_essay"
    t.integer "status"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "grades"
    t.string "uncorrectable_message"
    t.string "updated_by_uid"
    t.string "token"
    t.text "feedback"
    t.string "correction_type", default: "redacao-padrao"
    t.jsonb "appearance"
    t.integer "rating", default: 0
    t.jsonb "draft", default: {}, null: false
    t.text "draft_feedback"
    t.datetime "send_date"
    t.bigint "platform_id"
    t.datetime "deadline_at"
    t.index ["correction_style_id"], name: "index_essay_submissions_on_correction_style_id"
    t.index ["permalink_id"], name: "index_essay_submissions_on_permalink_id"
    t.index ["user_id"], name: "index_essay_submissions_on_user_id"
  end

  create_table "exercise_events", force: :cascade do |t|
    t.string "item_slug"
    t.string "medium_slug"
    t.string "submission_token"
    t.boolean "correct", default: false
    t.bigint "answer_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 0
    t.index ["answer_id"], name: "index_exercise_events_on_answer_id"
    t.index ["item_slug", "user_id"], name: "index_exercise_events_on_item_slug_and_user_id"
    t.index ["submission_token"], name: "index_exercise_events_on_submission_token"
    t.index ["user_id"], name: "index_exercise_events_on_user_id"
  end

  create_table "faqs", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "token"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_faqs_on_token"
  end

  create_table "favorites", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "playlist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["playlist_id"], name: "index_favorites_on_playlist_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "features", force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
    t.string "category"
  end

  create_table "forms", id: :serial, force: :cascade do |t|
    t.string "user_uid"
    t.string "metadata", array: true
    t.string "token"
    t.boolean "completed"
    t.index ["user_uid", "token"], name: "index_forms_on_user_uid_and_token", unique: true
  end

  create_table "images", id: :serial, force: :cascade do |t|
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "platform_id"
    t.string "created_by"
    t.index ["platform_id"], name: "index_images_on_platform_id"
  end

  create_table "instructor_last_checked_for_students", force: :cascade do |t|
    t.datetime "time"
  end

  create_table "instructor_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "instructor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["instructor_id"], name: "index_instructor_users_on_instructor_id"
    t.index ["user_id"], name: "index_instructor_users_on_user_id"
  end

  create_table "instructors", force: :cascade do |t|
    t.bigint "package_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "infos"
    t.index ["package_id"], name: "index_instructors_on_package_id"
    t.index ["user_id"], name: "index_instructors_on_user_id"
  end

  create_table "internal_logs", force: :cascade do |t|
    t.jsonb "log"
    t.string "category"
    t.string "log_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "item_media", id: :serial, force: :cascade do |t|
    t.integer "item_id"
    t.integer "medium_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["item_id", "medium_id"], name: "index_item_media_on_item_id_and_medium_id", unique: true
    t.index ["item_id"], name: "index_item_media_on_item_id"
    t.index ["medium_id"], name: "index_item_media_on_medium_id"
  end

  create_table "items", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.text "description"
    t.string "item_type"
    t.boolean "free", default: false
    t.boolean "active", default: true
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "created_by"
    t.string "updated_by"
    t.boolean "downloadable", default: true, null: false
    t.string "tag", array: true
    t.string "streaming_status"
    t.string "chat_token"
    t.text "meta_description"
    t.string "meta_title"
    t.jsonb "options", default: {}
    t.bigint "platform_id"
    t.string "token"
    t.boolean "listed", default: true
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.index ["chat_token"], name: "index_items_on_chat_token", unique: true
    t.index ["platform_id"], name: "index_items_on_platform_id"
    t.index ["starts_at", "ends_at", "item_type"], name: "index_items_on_starts_at_and_ends_at_and_item_type"
    t.index ["token"], name: "index_items_on_token", unique: true
  end

  create_table "lesson_events", force: :cascade do |t|
    t.string "node_module_slug"
    t.string "item_slug"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "submission_token"
    t.index ["node_module_slug", "user_id", "submission_token"], name: "index_lesson_events_on_module_and_user_and_token"
    t.index ["node_module_slug", "user_id"], name: "index_lesson_events_on_node_module_slug_and_user_id"
    t.index ["user_id"], name: "index_lesson_events_on_user_id"
  end

  create_table "lp_blocks", force: :cascade do |t|
    t.string "name", null: false
    t.jsonb "schema", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type_of", default: "section"
    t.jsonb "data", default: {}
    t.boolean "active", default: true
  end

  create_table "lp_pages", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.jsonb "schema", default: {}
    t.jsonb "data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
  end

  create_table "majors", id: :serial, force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_majors_on_name", unique: true
  end

  create_table "media", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "medium_type"
    t.string "attachment"
    t.integer "seconds_duration"
    t.text "medium_text"
    t.string "video_id"
    t.string "provider"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.string "code"
    t.text "correction"
    t.string "matter"
    t.string "subject"
    t.integer "difficulty"
    t.string "concourse"
    t.string "created_by"
    t.string "updated_by"
    t.boolean "active", default: true
    t.string "tag", array: true
    t.string "audit_status"
    t.string "placeholder"
    t.jsonb "options", default: {}, null: false
    t.bigint "platform_id"
    t.string "token"
    t.boolean "listed", default: true
    t.index ["medium_type"], name: "index_media_on_medium_type"
    t.index ["platform_id"], name: "index_media_on_platform_id"
    t.index ["slug"], name: "index_media_on_slug", unique: true
    t.index ["token"], name: "index_media_on_token", unique: true
  end

  create_table "medium_ratings", force: :cascade do |t|
    t.bigint "medium_id"
    t.bigint "user_id"
    t.integer "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["medium_id"], name: "index_medium_ratings_on_medium_id"
    t.index ["user_id"], name: "index_medium_ratings_on_user_id"
  end

  create_table "mentorings", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id"
    t.bigint "content_teacher_id"
    t.text "comment"
    t.integer "rating"
    t.datetime "starts_at"
    t.integer "simplybook_id"
    t.string "call_link"
    t.string "category", default: "mentoring"
    t.boolean "active", default: true
    t.index ["content_teacher_id"], name: "index_mentorings_on_content_teacher_id"
    t.index ["user_id"], name: "index_mentorings_on_user_id"
  end

  create_table "net_promoter_scores", id: :serial, force: :cascade do |t|
    t.integer "score"
    t.text "reason"
    t.string "promotable_type"
    t.integer "promotable_id"
    t.index ["promotable_type", "promotable_id"], name: "index_net_promoter_scores_on_promotable_type_and_promotable_id"
  end

  create_table "node_media", id: :serial, force: :cascade do |t|
    t.integer "node_id"
    t.integer "medium_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medium_id"], name: "index_node_media_on_medium_id"
    t.index ["node_id", "medium_id"], name: "index_node_media_on_node_id_and_medium_id", unique: true
    t.index ["node_id"], name: "index_node_media_on_node_id"
  end

  create_table "node_module_items", id: :serial, force: :cascade do |t|
    t.integer "node_module_id"
    t.integer "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["item_id"], name: "index_node_module_items_on_item_id"
    t.index ["node_module_id", "item_id"], name: "index_node_module_items_on_node_module_id_and_item_id", unique: true
    t.index ["node_module_id"], name: "index_node_module_items_on_node_module_id"
  end

  create_table "node_module_media", id: :serial, force: :cascade do |t|
    t.integer "node_module_id"
    t.integer "medium_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medium_id"], name: "index_node_module_media_on_medium_id"
    t.index ["node_module_id", "medium_id"], name: "index_node_module_media_on_node_module_id_and_medium_id", unique: true
    t.index ["node_module_id"], name: "index_node_module_media_on_node_module_id"
  end

  create_table "node_modules", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.text "description"
    t.string "suggested_to"
    t.string "pre_requisite"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.string "code"
    t.integer "old_id"
    t.string "created_by"
    t.string "updated_by"
    t.string "instructor_type"
    t.integer "instructor_id"
    t.integer "relevancy", default: 1
    t.integer "position"
    t.string "node_module_type", default: "default"
    t.text "meta_description"
    t.string "meta_title"
    t.string "color_hex"
    t.jsonb "options"
    t.bigint "platform_id"
    t.string "token"
    t.boolean "listed", default: true
    t.index ["instructor_type", "instructor_id"], name: "index_node_modules_on_instructor_type_and_instructor_id"
    t.index ["platform_id"], name: "index_node_modules_on_platform_id"
    t.index ["slug"], name: "index_node_modules_on_slug"
    t.index ["token"], name: "index_node_modules_on_token", unique: true
  end

  create_table "node_node_modules", id: :serial, force: :cascade do |t|
    t.integer "node_id"
    t.integer "node_module_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["node_id"], name: "index_node_node_modules_on_node_id"
    t.index ["node_module_id", "node_id"], name: "index_node_node_modules_on_node_module_id_and_node_id", unique: true
    t.index ["node_module_id"], name: "index_node_node_modules_on_node_module_id"
  end

  create_table "nodes", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "active", default: true
    t.string "slug"
    t.text "description"
    t.string "suggested_to"
    t.string "pre_requisite"
    t.string "image"
    t.string "node_type"
    t.string "color_hex"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ancestry"
    t.text "info"
    t.integer "old_id"
    t.string "video"
    t.integer "old_package_id"
    t.text "og_description"
    t.integer "position"
    t.text "meta_description"
    t.string "meta_title"
    t.jsonb "options"
    t.bigint "platform_id"
    t.string "token"
    t.boolean "listed", default: true
    t.index ["ancestry"], name: "index_nodes_on_ancestry"
    t.index ["id", "ancestry"], name: "index_nodes_on_id_and_ancestry"
    t.index ["node_type"], name: "index_nodes_on_node_type"
    t.index ["platform_id"], name: "index_nodes_on_platform_id"
    t.index ["token"], name: "index_nodes_on_token", unique: true
  end

  create_table "nodes_packages", id: false, force: :cascade do |t|
    t.integer "package_id", null: false
    t.integer "node_id", null: false
    t.index ["node_id", "package_id"], name: "index_nodes_packages_on_node_id_and_package_id"
    t.index ["package_id", "node_id"], name: "index_nodes_packages_on_package_id_and_node_id"
  end

  create_table "notification_events", force: :cascade do |t|
    t.integer "user_id"
    t.integer "notification_id"
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_id"], name: "index_notification_events_on_notification_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "notification_type"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "objectives", id: :serial, force: :cascade do |t|
    t.string "education_segment_slug"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.boolean "active", default: true, null: false
    t.string "crm_name"
    t.index ["name"], name: "index_objectives_on_name", unique: true
    t.index ["position"], name: "index_objectives_on_position"
  end

  create_table "order_payment_transitions", id: :serial, force: :cascade do |t|
    t.string "to_state", null: false
    t.json "metadata", default: "{}"
    t.integer "sort_key", null: false
    t.integer "order_payment_id", null: false
    t.boolean "most_recent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_payment_id", "most_recent"], name: "index_order_payment_transitions_parent_most_recent", unique: true, where: "most_recent"
    t.index ["order_payment_id", "sort_key"], name: "index_order_payment_transitions_parent_sort", unique: true
  end

  create_table "order_payments", id: :serial, force: :cascade do |t|
    t.integer "order_id"
    t.string "payment_method", null: false
    t.integer "amount_in_cents", null: false
    t.integer "installments", null: false
    t.string "card_token"
    t.jsonb "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "invoice_id"
    t.string "pdf"
    t.string "error_message"
    t.string "error_code"
    t.string "barcode"
    t.boolean "reprocessed", default: false
    t.index ["order_id"], name: "index_order_payments_on_order_id"
  end

  create_table "order_transitions", id: :serial, force: :cascade do |t|
    t.string "to_state", null: false
    t.text "metadata", default: "{}"
    t.integer "sort_key", null: false
    t.integer "order_id", null: false
    t.boolean "most_recent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id", "most_recent"], name: "index_order_transitions_parent_most_recent", unique: true, where: "most_recent"
    t.index ["order_id", "sort_key"], name: "index_order_transitions_parent_sort", unique: true
  end

  create_table "orders", id: :serial, force: :cascade do |t|
    t.integer "package_id"
    t.integer "user_id"
    t.decimal "price_paid"
    t.datetime "expires_at"
    t.integer "status"
    t.string "broker"
    t.string "checkout_method"
    t.integer "purchase_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "broker_data"
    t.boolean "processed", default: false
    t.integer "installments", default: 1
    t.string "broker_invoice"
    t.integer "order_event", default: 1
    t.string "email"
    t.string "cpf"
    t.string "nationality"
    t.string "token"
    t.integer "subscription_id"
    t.integer "discount_id"
    t.integer "discount_in_cents", default: 0, null: false
    t.string "currency"
    t.string "phone_area"
    t.string "phone_number"
    t.boolean "buzzlead_processed", default: false
    t.string "payment_proof"
    t.integer "complementary_package_ids", default: [], array: true
    t.json "facebook_ads_infos", default: {}
    t.string "delivery_status"
    t.string "tracking_code"
    t.integer "bling_id"
    t.index ["discount_id"], name: "index_orders_on_discount_id"
    t.index ["package_id"], name: "index_orders_on_package_id"
    t.index ["subscription_id"], name: "index_orders_on_subscription_id"
    t.index ["token"], name: "index_orders_on_token", unique: true
    t.index ["user_id", "token"], name: "index_orders_on_user_id_and_token"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "package_features", force: :cascade do |t|
    t.bigint "package_id"
    t.bigint "feature_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_id"], name: "index_package_features_on_feature_id"
    t.index ["package_id"], name: "index_package_features_on_package_id"
  end

  create_table "packages", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "duration"
    t.datetime "expires_at"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "iugu_plan_id"
    t.string "iugu_plan_identifier"
    t.boolean "subscription", default: false
    t.integer "max_payments", default: 1
    t.text "description"
    t.text "info", array: true
    t.boolean "listed", default: false, null: false
    t.string "form"
    t.integer "position", default: 0
    t.string "pagarme_plan_id"
    t.string "play_store_product_id"
    t.string "app_store_product_id"
    t.string "education_segment_slug"
    t.string "sales_platforms", array: true
    t.integer "education_segment_id"
    t.text "label", default: [], array: true
    t.integer "essay_credits"
    t.boolean "unlimited_essay_credits"
    t.jsonb "options", default: {}, null: false
    t.string "color_hex"
    t.string "image"
    t.integer "max_pending_essay", default: 2
    t.string "package_type"
    t.string "sku"
    t.boolean "complementary", default: false
    t.integer "private_class_credits", default: 0
    t.bigint "tangible_product_id"
    t.float "tangible_product_discount_percent"
    t.index ["education_segment_slug"], name: "index_packages_on_education_segment_slug"
    t.index ["slug"], name: "index_packages_on_slug", unique: true
    t.index ["tangible_product_id"], name: "index_packages_on_tangible_product_id"
  end

  create_table "pagarme_subscriptions", id: :serial, force: :cascade do |t|
    t.string "pagarme_id"
    t.integer "subscription_id"
    t.jsonb "metadata"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.index ["subscription_id"], name: "index_pagarme_subscriptions_on_subscription_id"
  end

  create_table "pagarme_transactions", id: :serial, force: :cascade do |t|
    t.string "transaction_id"
    t.integer "order_payment_id"
    t.jsonb "metadata"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.index ["order_payment_id"], name: "index_pagarme_transactions_on_order_payment_id"
  end

  create_table "partner_accesses", force: :cascade do |t|
    t.string "cpf"
    t.date "birth_date"
    t.string "partner"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "school"
    t.string "city"
    t.string "student_name"
    t.bigint "platform_schools_id"
    t.index ["platform_schools_id"], name: "index_partner_accesses_on_platform_schools_id"
    t.index ["user_id"], name: "index_partner_accesses_on_user_id"
  end

  create_table "permalink_events", id: :serial, force: :cascade do |t|
    t.string "permalink_slug"
    t.string "permalink_node", array: true
    t.string "permalink_node_module"
    t.string "permalink_item"
    t.string "permalink_medium"
    t.integer "permalink_node_id", array: true
    t.integer "permalink_node_module_id"
    t.integer "permalink_item_id"
    t.integer "permalink_medium_id"
    t.string "permalink_node_type", array: true
    t.string "permalink_item_type"
    t.string "permalink_medium_type"
    t.string "permalink_node_slug", array: true
    t.string "permalink_node_module_slug"
    t.string "permalink_item_slug"
    t.string "permalink_medium_slug"
    t.integer "permalink_answer_id", default: 0
    t.boolean "permalink_answer_correct"
    t.integer "user_id"
    t.string "user_name"
    t.string "user_email"
    t.boolean "user_premium"
    t.string "user_objective"
    t.integer "user_objective_id"
    t.string "event_name"
    t.datetime "created_at", null: false
    t.string "location"
    t.string "client"
    t.string "device"
    t.string "user_agent"
    t.integer "content_rating"
    t.datetime "submission_at"
    t.string "submission_token"
    t.datetime "starts_at"
    t.string "source_name", default: "default"
    t.string "source_id"
    t.jsonb "utm"
    t.index ["created_at"], name: "index_permalink_events_on_created_at"
    t.index ["user_id", "permalink_slug"], name: "permalink_events_user_id_permalink_slug_idx"
    t.index ["user_id"], name: "permalink_events_user_id_idx"
  end

  create_table "permalink_nodes", id: :serial, force: :cascade do |t|
    t.integer "permalink_id"
    t.integer "node_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["node_id"], name: "index_permalink_nodes_on_node_id"
    t.index ["permalink_id"], name: "index_permalink_nodes_on_permalink_id"
    t.index ["position"], name: "index_permalink_nodes_on_position"
  end

  create_table "permalink_suggestions", id: :serial, force: :cascade do |t|
    t.string "slug"
    t.string "suggestion_slug"
    t.string "suggestion_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permalinks", id: :serial, force: :cascade do |t|
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "node_module_id"
    t.integer "item_id"
    t.integer "medium_id"
    t.integer "permalink_id"
    t.string "canonical_uri"
    t.index ["canonical_uri"], name: "index_permalinks_on_canonical_uri"
    t.index ["item_id"], name: "index_permalinks_on_item_id"
    t.index ["medium_id"], name: "index_permalinks_on_medium_id"
    t.index ["node_module_id"], name: "index_permalinks_on_node_module_id"
    t.index ["permalink_id"], name: "index_permalinks_on_permalink_id"
    t.index ["slug"], name: "index_permalinks_on_slug", unique: true
  end

  create_table "permalinks_playlists", id: false, force: :cascade do |t|
    t.integer "playlist_id", null: false
    t.integer "permalink_id", null: false
    t.index ["permalink_id", "playlist_id"], name: "index_permalinks_playlists_on_permalink_id_and_playlist_id"
    t.index ["playlist_id", "permalink_id"], name: "index_permalinks_playlists_on_playlist_id_and_permalink_id", unique: true
  end

  create_table "permission_roles", force: :cascade do |t|
    t.bigint "role_id"
    t.bigint "permission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_id"], name: "index_permission_roles_on_permission_id"
    t.index ["role_id"], name: "index_permission_roles_on_role_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "context"
    t.string "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "permission_type"
    t.text "description"
    t.index ["context", "action"], name: "index_permissions_on_context_and_action", unique: true
  end

  create_table "platform_schools", force: :cascade do |t|
    t.string "name", null: false
    t.string "city", null: false
    t.bigint "platform_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["platform_id"], name: "index_platform_schools_on_platform_id"
  end

  create_table "platform_unities", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "uf"
    t.string "city"
    t.bigint "platform_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ancestry"
    t.string "category"
    t.index ["platform_id"], name: "index_platform_unities_on_platform_id"
  end

  create_table "platform_vouchers", force: :cascade do |t|
    t.bigint "platform_id"
    t.string "token"
    t.string "email"
    t.integer "duration", default: 30
    t.bigint "user_id"
    t.bigint "package_id"
    t.jsonb "options", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["package_id"], name: "index_platform_vouchers_on_package_id"
    t.index ["platform_id"], name: "index_platform_vouchers_on_platform_id"
    t.index ["token"], name: "index_platform_vouchers_on_token", unique: true
    t.index ["user_id"], name: "index_platform_vouchers_on_user_id"
  end

  create_table "platforms", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.jsonb "theme", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "navigation", default: {}, null: false
    t.bigint "node_id"
    t.jsonb "panel", default: {}
    t.string "domain"
    t.jsonb "options", default: {}
    t.boolean "dedicated_essay", default: false
    t.string "cnpj"
    t.string "mail_invite"
    t.string "mail_grant_access"
    t.string "unity_types", default: ["Unidade"], array: true
    t.index ["cnpj"], name: "index_platforms_on_cnpj", unique: true
  end

  create_table "play_store_transactions", id: :serial, force: :cascade do |t|
    t.string "transaction_id"
    t.integer "order_payment_id"
    t.json "metadata"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.index ["order_payment_id"], name: "index_play_store_transactions_on_order_payment_id"
  end

  create_table "playlist_avatars", id: :serial, force: :cascade do |t|
    t.string "image"
    t.boolean "listed", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "playlist_permalinks", id: :serial, force: :cascade do |t|
    t.integer "playlist_id"
    t.integer "permalink_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permalink_id"], name: "index_playlist_permalinks_on_permalink_id"
    t.index ["playlist_id"], name: "index_playlist_permalinks_on_playlist_id"
    t.index ["position"], name: "index_playlist_permalinks_on_position"
  end

  create_table "playlists", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.boolean "free"
    t.integer "seconds_duration"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
    t.string "visibility"
    t.string "course"
    t.string "teacher"
    t.integer "items_count"
    t.integer "college_id"
    t.integer "major_id"
    t.integer "playlist_avatar_id"
    t.index ["playlist_avatar_id"], name: "index_playlists_on_playlist_avatar_id"
    t.index ["user_id"], name: "index_playlists_on_user_id"
  end

  create_table "post_buy_notification_campaigns", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.date "notified_at"
    t.boolean "active", default: true
    t.string "notification_type"
    t.integer "package_ids", array: true
  end

  create_table "prep_test_details", force: :cascade do |t|
    t.string "token"
    t.jsonb "options", default: {}
    t.integer "weight"
    t.string "suggestion_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_prep_test_details_on_token"
  end

  create_table "prep_test_overviews", force: :cascade do |t|
    t.string "user_uid"
    t.string "token"
    t.float "score"
    t.string "permalink_slug"
    t.integer "corrects"
    t.jsonb "answers", default: []
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_uid"], name: "index_prep_test_overviews_on_user_uid"
  end

  create_table "prep_test_scores", id: :serial, force: :cascade do |t|
    t.float "score"
    t.string "permalink_slug"
    t.string "submission_token"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "prep_test_id"
    t.index ["permalink_slug"], name: "index_prep_test_scores_on_permalink_slug"
    t.index ["submission_token"], name: "index_prep_test_scores_on_submission_token"
    t.index ["user_id"], name: "index_prep_test_scores_on_user_id"
  end

  create_table "prep_tests", force: :cascade do |t|
    t.float "cnat_min_score"
    t.float "cnat_average_score"
    t.float "cnat_max_score"
    t.float "chum_min_score"
    t.float "chum_average_score"
    t.float "chum_max_score"
    t.float "ling_ing_min_score"
    t.float "ling_ing_average_score"
    t.float "ling_ing_max_score"
    t.float "mat_min_score"
    t.float "mat_average_score"
    t.float "mat_max_score"
    t.string "permalink_slug"
    t.date "average_measured_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cnat_average_correct"
    t.integer "chum_average_correct"
    t.integer "ling_ing_average_correct"
    t.integer "mat_average_correct"
    t.float "ling_esp_min_score"
    t.float "ling_esp_average_score"
    t.float "ling_esp_max_score"
    t.integer "ling_esp_average_correct"
    t.index ["permalink_slug"], name: "index_prep_tests_on_permalink_slug", unique: true
  end

  create_table "prices", id: :serial, force: :cascade do |t|
    t.decimal "value"
    t.boolean "active", default: true
    t.integer "package_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "price_type"
    t.string "currency", default: "BRL", null: false
    t.index ["package_id"], name: "index_prices_on_package_id"
  end

  create_table "public_document_infos", id: :serial, force: :cascade do |t|
    t.string "document_type"
    t.string "teacher"
    t.string "course"
    t.integer "major_id"
    t.integer "college_id"
    t.integer "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["college_id"], name: "index_public_document_infos_on_college_id"
    t.index ["item_id"], name: "index_public_document_infos_on_item_id"
    t.index ["major_id"], name: "index_public_document_infos_on_major_id"
  end

  create_table "questions", id: :serial, force: :cascade do |t|
    t.text "title"
    t.text "answer"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "created_by"
    t.string "updated_by"
    t.string "token"
    t.integer "faq_id"
  end

  create_table "quiz_alternatives", id: :serial, force: :cascade do |t|
    t.integer "quiz_question_id"
    t.string "description"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.index ["quiz_question_id"], name: "index_quiz_alternatives_on_quiz_question_id"
  end

  create_table "quiz_answers", id: :serial, force: :cascade do |t|
    t.integer "quiz_question_id"
    t.integer "quiz_alternative_id"
    t.integer "quiz_form_submission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["quiz_alternative_id"], name: "index_quiz_answers_on_quiz_alternative_id"
    t.index ["quiz_form_submission_id"], name: "index_quiz_answers_on_quiz_form_submission_id"
    t.index ["quiz_question_id"], name: "index_quiz_answers_on_quiz_question_id"
  end

  create_table "quiz_form_submissions", id: :serial, force: :cascade do |t|
    t.integer "quiz_form_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_form_id"], name: "index_quiz_form_submissions_on_quiz_form_id"
    t.index ["user_id"], name: "index_quiz_form_submissions_on_user_id"
  end

  create_table "quiz_forms", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "active"
    t.string "form_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quiz_questions", id: :serial, force: :cascade do |t|
    t.integer "quiz_form_id"
    t.string "statement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "question_type"
    t.text "description"
    t.integer "position"
    t.boolean "required", default: false
    t.index ["quiz_form_id"], name: "index_quiz_questions_on_quiz_form_id"
  end

  create_table "rates", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "playlist_id"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["playlist_id"], name: "index_rates_on_playlist_id"
    t.index ["user_id", "playlist_id"], name: "index_rates_on_user_id_and_playlist_id", unique: true
    t.index ["user_id"], name: "index_rates_on_user_id"
  end

  create_table "rdstation_logs", force: :cascade do |t|
    t.string "trigger"
    t.json "leads"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", default: "student"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.text "description"
    t.string "role_type", default: "admin"
    t.index ["slug"], name: "index_roles_on_slug", unique: true
  end

  create_table "scholar_records", id: :serial, force: :cascade do |t|
    t.string "education_level"
    t.integer "user_id"
    t.boolean "level_concluded", default: false, null: false
    t.integer "major_id"
    t.integer "school_id"
    t.integer "college_id"
    t.integer "study_phase"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_role"
    t.index ["college_id"], name: "index_scholar_records_on_college_id"
    t.index ["major_id"], name: "index_scholar_records_on_major_id"
    t.index ["school_id"], name: "index_scholar_records_on_school_id"
    t.index ["user_id"], name: "index_scholar_records_on_user_id"
  end

  create_table "schools", id: :serial, force: :cascade do |t|
    t.string "uf"
    t.string "city"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "inep_id"
  end

  create_table "search_data", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "link"
    t.string "description"
    t.string "text"
    t.string "attachment"
    t.string "entity_type"
    t.string "entity"
    t.string "permalink_slug"
    t.string "education_segment"
    t.string "second_level_slug"
    t.integer "popularity"
    t.integer "node_id"
    t.integer "node_module_id"
    t.integer "item_id"
    t.integer "medium_id"
    t.integer "permalink_id"
    t.boolean "free"
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
  end

  create_table "shortened_urls", force: :cascade do |t|
    t.integer "owner_id"
    t.string "owner_type", limit: 20
    t.text "url", null: false
    t.string "unique_key", limit: 10, null: false
    t.string "category"
    t.integer "use_count", default: 0, null: false
    t.datetime "expires_at"
    t.bigint "owner_id_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_shortened_urls_on_category"
    t.index ["owner_id", "owner_type"], name: "index_shortened_urls_on_owner_id_and_owner_type"
    t.index ["owner_id_id"], name: "index_shortened_urls_on_owner_id_id"
    t.index ["unique_key"], name: "index_shortened_urls_on_unique_key", unique: true
    t.index ["url"], name: "index_shortened_urls_on_url"
  end

  create_table "sisu_institutes", id: :serial, force: :cascade do |t|
    t.string "year"
    t.string "ies"
    t.string "course"
    t.string "grade"
    t.string "shift"
    t.string "modality"
    t.string "passing_score"
    t.string "state"
    t.string "initials"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "semester"
    t.boolean "trans", default: false
    t.boolean "indigena", default: false
    t.boolean "deficiencia", default: false
    t.boolean "publica", default: false
    t.boolean "carente", default: false
    t.boolean "afro", default: false
    t.index ["course"], name: "index_sisu_institutes_on_course"
    t.index ["modality"], name: "index_sisu_institutes_on_modality"
    t.index ["semester"], name: "index_sisu_institutes_on_semester"
    t.index ["shift"], name: "index_sisu_institutes_on_shift"
    t.index ["state"], name: "index_sisu_institutes_on_state"
    t.index ["year"], name: "index_sisu_institutes_on_year"
  end

  create_table "sisu_reports", force: :cascade do |t|
    t.string "no_ies"
    t.string "sg_ies"
    t.string "ds_organizacao_academica"
    t.string "ds_categoria_adm"
    t.string "no_campus"
    t.string "sg_uf_campus"
    t.string "no_municipio_campus"
    t.string "ds_regiao"
    t.string "no_curso"
    t.string "ds_grau"
    t.string "ds_turno"
    t.string "ds_periodicidade"
    t.integer "qt_semestre"
    t.integer "nu_vagas_autorizadas"
    t.integer "qt_vagas_ofertadas"
    t.string "tp_modalidade"
    t.string "ds_mod_concorrencia"
    t.integer "peso_redacao"
    t.integer "peso_linguagens"
    t.integer "peso_matematica"
    t.integer "peso_ciencias_humanas"
    t.integer "peso_ciencias_natureza"
    t.float "nota_corte"
    t.integer "year"
    t.integer "edition"
    t.boolean "afrodecendente"
    t.boolean "carente"
    t.boolean "publica"
    t.boolean "deficiencia"
    t.boolean "indigena"
    t.boolean "trans"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sisu_satisfactions", force: :cascade do |t|
    t.boolean "satisfaction", default: false
    t.string "plan"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sisu_satisfactions_on_user_id"
  end

  create_table "sisu_scores", id: :serial, force: :cascade do |t|
    t.string "initials"
    t.string "ies"
    t.string "college"
    t.string "course"
    t.string "grade"
    t.string "shift"
    t.string "modality"
    t.string "semester"
    t.float "cnat_weight"
    t.float "chum_weight"
    t.float "ling_weight"
    t.float "mat_weight"
    t.float "red_weight"
    t.float "cnat_score"
    t.float "chum_score"
    t.float "ling_score"
    t.float "mat_score"
    t.float "red_score"
    t.float "cnat_avg"
    t.float "chum_avg"
    t.float "ling_avg"
    t.float "mat_avg"
    t.float "red_avg"
    t.float "passing_score"
    t.float "average"
    t.string "chances"
    t.integer "quiz_form_submission_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "trans", default: false
    t.boolean "indigena", default: false
    t.boolean "deficiencia", default: false
    t.boolean "publica", default: false
    t.boolean "carente", default: false
    t.boolean "afro", default: false
    t.boolean "allowed", default: false
    t.index ["quiz_form_submission_id"], name: "index_sisu_scores_on_quiz_form_submission_id"
    t.index ["user_id"], name: "index_sisu_scores_on_user_id"
  end

  create_table "sisu_weightings", id: :serial, force: :cascade do |t|
    t.string "institute"
    t.string "college"
    t.string "course"
    t.string "shift"
    t.float "cnat_weight"
    t.float "chum_weight"
    t.float "ling_weight"
    t.float "mat_weight"
    t.float "red_weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "year"
    t.string "semester"
    t.index ["course"], name: "index_sisu_weightings_on_course"
    t.index ["institute"], name: "index_sisu_weightings_on_institute"
    t.index ["semester"], name: "index_sisu_weightings_on_semester"
    t.index ["shift"], name: "index_sisu_weightings_on_shift"
    t.index ["year"], name: "index_sisu_weightings_on_year"
  end

  create_table "study_plan_node_modules", id: :serial, force: :cascade do |t|
    t.integer "study_plan_id", null: false
    t.integer "node_module_id", null: false
    t.string "comment"
    t.date "date"
    t.string "weekday"
    t.string "shift"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "completed", default: false
    t.boolean "already_known", default: false
    t.integer "position"
    t.boolean "skipped", default: false
    t.index ["node_module_id"], name: "index_study_plan_node_modules_on_node_module_id"
    t.index ["study_plan_id"], name: "index_study_plan_node_modules_on_study_plan_id"
  end

  create_table "study_plans", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "quiz_form_submission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "estimated_weeks"
    t.integer "offset", default: 0
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean "active", default: true
    t.integer "limit", default: 0
    t.integer "subject_ids", default: [], array: true
    t.json "shifts", default: {}
    t.integer "available_time", default: 0
    t.boolean "keep_completed_modules", default: true
    t.index ["quiz_form_submission_id"], name: "index_study_plans_on_quiz_form_submission_id"
    t.index ["user_id"], name: "index_study_plans_on_user_id"
  end

  create_table "subscriptions", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.boolean "active"
    t.string "broker_id"
    t.string "token"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_subscriptions_on_token", unique: true
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "system_settings", force: :cascade do |t|
    t.string "key", null: false
    t.json "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_system_settings_on_key", unique: true
  end

  create_table "tangible_products", force: :cascade do |t|
    t.string "name"
    t.float "height"
    t.float "length"
    t.float "width"
    t.float "weight"
    t.text "description"
    t.string "sku"
    t.string "image"
  end

  create_table "teachers", id: :serial, force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "description"
    t.date "birth_date"
    t.boolean "active", default: true, null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.integer "invited_by_id"
    t.integer "invitations_count", default: 0
    t.index ["confirmed_at"], name: "index_teachers_on_confirmed_at"
    t.index ["email"], name: "index_teachers_on_email"
    t.index ["invitation_token"], name: "index_teachers_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_teachers_on_invitations_count"
    t.index ["invited_by_id"], name: "index_teachers_on_invited_by_id"
    t.index ["reset_password_token"], name: "index_teachers_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_teachers_on_uid_and_provider", unique: true
  end

  create_table "testimonials", id: :serial, force: :cascade do |t|
    t.string "education_segment_slug"
    t.string "avatar"
    t.string "user_name"
    t.string "email"
    t.string "phone"
    t.boolean "sts_authorization"
    t.boolean "marketing_authorization"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "created_by"
    t.string "updated_by"
    t.string "token"
  end

  create_table "tri_references", force: :cascade do |t|
    t.bigint "item_id"
    t.integer "year"
    t.string "exam"
    t.string "language"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "application", default: 1
    t.string "color", default: "blue"
    t.index ["item_id"], name: "index_tri_references_on_item_id"
  end

  create_table "user_counters", force: :cascade do |t|
    t.string "period_type"
    t.bigint "user_id"
    t.string "period"
    t.integer "video"
    t.integer "text"
    t.integer "exercise"
    t.integer "public_document"
    t.integer "essay"
    t.integer "book"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "streaming"
    t.index ["period_type", "user_id", "period"], name: "index_user_counters_on_period_type_and_user_id_and_period"
    t.index ["user_id"], name: "index_user_counters_on_user_id"
  end

  create_table "user_platforms", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "platform_id"
    t.string "role", default: "student"
    t.boolean "verified", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
    t.jsonb "options", default: {}, null: false
    t.boolean "active", default: true
    t.string "unity"
    t.bigint "platform_unity_id"
    t.index ["platform_id"], name: "index_user_platforms_on_platform_id"
    t.index ["platform_unity_id"], name: "index_user_platforms_on_platform_unity_id"
    t.index ["user_id"], name: "index_user_platforms_on_user_id"
  end

  create_table "user_referrals", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "last_checked"
    t.boolean "being_processed", default: false
    t.integer "confirmed_referrals", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_referrals_on_user_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.bigint "role_id"
    t.bigint "user_id"
    t.bigint "user_platform_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
    t.index ["user_platform_id"], name: "index_user_roles_on_user_platform_id"
  end

  create_table "user_settings", force: :cascade do |t|
    t.bigint "user_id"
    t.string "key"
    t.json "value"
    t.index ["key", "user_id"], name: "index_user_settings_on_key_and_user_id", unique: true
    t.index ["user_id"], name: "index_user_settings_on_user_id"
  end

  create_table "user_transitions", force: :cascade do |t|
    t.string "to_state", null: false
    t.text "metadata", default: "{}"
    t.integer "sort_key", null: false
    t.integer "user_id", null: false
    t.boolean "most_recent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "most_recent"], name: "index_user_transitions_parent_most_recent", unique: true, where: "most_recent"
    t.index ["user_id", "sort_key"], name: "index_user_transitions_parent_sort", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "image"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date "birth_date"
    t.string "gender"
    t.string "studies"
    t.string "dreams"
    t.integer "objective_id"
    t.string "iugu_customer_id"
    t.integer "education_level_id"
    t.string "origin"
    t.boolean "active", default: true, null: false
    t.string "facebook_uid"
    t.string "google_uid"
    t.string "pagarme_customer_id"
    t.string "phone_area"
    t.string "phone_number"
    t.string "profile"
    t.string "token", default: ""
    t.string "apple_uid"
    t.jsonb "options", default: {}
    t.string "crm_email"
    t.string "enem_subscription_id"
    t.integer "premium_status"
    t.index ["apple_uid"], name: "index_users_on_apple_uid"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token"
    t.index ["confirmed_at"], name: "index_users_on_confirmed_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["facebook_uid"], name: "index_users_on_facebook_uid"
    t.index ["google_uid"], name: "index_users_on_google_uid"
    t.index ["objective_id"], name: "index_users_on_objective_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["token"], name: "index_users_on_token"
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
    t.index ["uid"], name: "index_users_on_uid"
  end

  create_table "utms", id: :serial, force: :cascade do |t|
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "referenceable_type"
    t.integer "referenceable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["referenceable_type", "referenceable_id"], name: "index_utms_on_referenceable_type_and_referenceable_id"
  end

  create_table "vouchers", id: :serial, force: :cascade do |t|
    t.string "token"
    t.boolean "active", default: true
    t.integer "user_id"
    t.integer "order_id"
    t.integer "access_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "campaign"
    t.index ["access_id"], name: "index_vouchers_on_access_id"
    t.index ["order_id"], name: "index_vouchers_on_order_id"
    t.index ["user_id"], name: "index_vouchers_on_user_id"
  end

  add_foreign_key "academic_infos", "users"
  add_foreign_key "accesses", "orders"
  add_foreign_key "accesses", "packages"
  add_foreign_key "accesses", "platforms"
  add_foreign_key "accesses", "users"
  add_foreign_key "answers", "media"
  add_foreign_key "app_store_transactions", "order_payments"
  add_foreign_key "bookshop_gifts", "bookshop_gift_packages"
  add_foreign_key "complementary_packages", "packages", column: "child_package_id"
  add_foreign_key "content_teacher_items", "content_teachers"
  add_foreign_key "content_teacher_items", "items"
  add_foreign_key "correction_style_criteria", "correction_styles"
  add_foreign_key "correction_style_criteria_checks", "correction_style_criteria", column: "correction_style_criteria_id"
  add_foreign_key "enem_answer_grids", "quiz_form_submissions"
  add_foreign_key "enem_answer_grids", "users"
  add_foreign_key "enem_answers", "enem_answer_grids"
  add_foreign_key "enem_answers", "quiz_alternatives"
  add_foreign_key "enem_answers", "quiz_form_submissions"
  add_foreign_key "enem_answers", "quiz_questions"
  add_foreign_key "essay_correction_checks", "correction_style_criteria_checks"
  add_foreign_key "essay_correction_checks", "essay_submissions"
  add_foreign_key "essay_events", "essay_submissions"
  add_foreign_key "essay_marks", "essay_submissions"
  add_foreign_key "essay_submission_grades", "correction_style_criteria", column: "correction_style_criteria_id"
  add_foreign_key "essay_submission_grades", "essay_submissions"
  add_foreign_key "essay_submissions", "correction_styles"
  add_foreign_key "essay_submissions", "permalinks"
  add_foreign_key "essay_submissions", "platforms"
  add_foreign_key "essay_submissions", "users"
  add_foreign_key "exercise_events", "answers"
  add_foreign_key "exercise_events", "users"
  add_foreign_key "favorites", "playlists"
  add_foreign_key "favorites", "users"
  add_foreign_key "images", "platforms"
  add_foreign_key "instructor_users", "instructors"
  add_foreign_key "instructor_users", "users"
  add_foreign_key "instructors", "packages"
  add_foreign_key "instructors", "users"
  add_foreign_key "item_media", "items"
  add_foreign_key "item_media", "media"
  add_foreign_key "items", "platforms"
  add_foreign_key "lesson_events", "users"
  add_foreign_key "media", "platforms"
  add_foreign_key "medium_ratings", "media"
  add_foreign_key "medium_ratings", "users"
  add_foreign_key "mentorings", "content_teachers"
  add_foreign_key "mentorings", "users"
  add_foreign_key "node_media", "media"
  add_foreign_key "node_media", "nodes"
  add_foreign_key "node_module_items", "items"
  add_foreign_key "node_module_items", "node_modules"
  add_foreign_key "node_module_media", "media"
  add_foreign_key "node_module_media", "node_modules"
  add_foreign_key "node_modules", "platforms"
  add_foreign_key "node_node_modules", "node_modules"
  add_foreign_key "node_node_modules", "nodes"
  add_foreign_key "nodes", "platforms"
  add_foreign_key "order_payments", "orders"
  add_foreign_key "orders", "discounts"
  add_foreign_key "orders", "packages"
  add_foreign_key "orders", "subscriptions"
  add_foreign_key "orders", "users"
  add_foreign_key "package_features", "features"
  add_foreign_key "package_features", "packages"
  add_foreign_key "pagarme_subscriptions", "subscriptions"
  add_foreign_key "pagarme_transactions", "order_payments"
  add_foreign_key "partner_accesses", "platform_schools", column: "platform_schools_id"
  add_foreign_key "partner_accesses", "users"
  add_foreign_key "permalink_nodes", "nodes"
  add_foreign_key "permalink_nodes", "permalinks", on_delete: :cascade
  add_foreign_key "permalinks", "item_media", column: "item_id", primary_key: "item_id", name: "permalinks_fk", on_delete: :cascade
  add_foreign_key "permalinks", "items"
  add_foreign_key "permalinks", "media"
  add_foreign_key "permalinks", "node_module_items", column: "node_module_id", primary_key: "node_module_id", name: "permalinks_fk1", on_delete: :cascade
  add_foreign_key "permalinks", "node_modules"
  add_foreign_key "permalinks", "permalinks", on_delete: :cascade
  add_foreign_key "permission_roles", "permissions"
  add_foreign_key "permission_roles", "roles"
  add_foreign_key "platform_schools", "platforms"
  add_foreign_key "platform_unities", "platforms"
  add_foreign_key "platform_vouchers", "packages"
  add_foreign_key "platform_vouchers", "platforms"
  add_foreign_key "platform_vouchers", "users"
  add_foreign_key "platforms", "nodes"
  add_foreign_key "play_store_transactions", "order_payments"
  add_foreign_key "playlist_permalinks", "permalinks"
  add_foreign_key "playlist_permalinks", "playlists"
  add_foreign_key "playlists", "colleges"
  add_foreign_key "playlists", "majors"
  add_foreign_key "playlists", "playlist_avatars"
  add_foreign_key "prep_test_scores", "users"
  add_foreign_key "prices", "packages"
  add_foreign_key "public_document_infos", "colleges"
  add_foreign_key "public_document_infos", "items"
  add_foreign_key "public_document_infos", "majors"
  add_foreign_key "questions", "faqs"
  add_foreign_key "quiz_alternatives", "quiz_questions", on_delete: :cascade
  add_foreign_key "quiz_answers", "quiz_alternatives", on_delete: :cascade
  add_foreign_key "quiz_answers", "quiz_form_submissions", on_delete: :cascade
  add_foreign_key "quiz_answers", "quiz_questions", on_delete: :cascade
  add_foreign_key "quiz_form_submissions", "quiz_forms", on_delete: :cascade
  add_foreign_key "quiz_form_submissions", "users"
  add_foreign_key "quiz_questions", "quiz_forms", on_delete: :cascade
  add_foreign_key "rates", "playlists"
  add_foreign_key "rates", "users"
  add_foreign_key "scholar_records", "colleges"
  add_foreign_key "scholar_records", "majors"
  add_foreign_key "scholar_records", "schools"
  add_foreign_key "scholar_records", "users"
  add_foreign_key "shortened_urls", "users", column: "owner_id_id"
  add_foreign_key "sisu_satisfactions", "users"
  add_foreign_key "sisu_scores", "quiz_form_submissions"
  add_foreign_key "sisu_scores", "users"
  add_foreign_key "study_plan_node_modules", "node_modules", on_delete: :cascade
  add_foreign_key "study_plan_node_modules", "study_plans", on_delete: :cascade
  add_foreign_key "study_plans", "quiz_form_submissions", on_delete: :cascade
  add_foreign_key "study_plans", "users", on_delete: :cascade
  add_foreign_key "subscriptions", "users"
  add_foreign_key "tri_references", "items"
  add_foreign_key "user_counters", "users"
  add_foreign_key "user_platforms", "platforms"
  add_foreign_key "user_platforms", "users"
  add_foreign_key "user_referrals", "users"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "user_platforms"
  add_foreign_key "user_roles", "users"
  add_foreign_key "user_settings", "users"
  add_foreign_key "users", "objectives"
  add_foreign_key "vouchers", "accesses"
  add_foreign_key "vouchers", "orders"
  add_foreign_key "vouchers", "users"
end
