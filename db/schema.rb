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

ActiveRecord::Schema.define(version: 20181206073249) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "additional_services", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "picture"
    t.string "mobile_number"
    t.string "website"
    t.text "description"
    t.boolean "is_active", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_additional_services_on_deleted_at"
    t.index ["email"], name: "index_additional_services_on_email"
    t.index ["is_active"], name: "index_additional_services_on_is_active"
    t.index ["name"], name: "index_additional_services_on_name"
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_super_admin", default: false
    t.string "avatar"
    t.string "name"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.datetime "deleted_at"
    t.integer "unread_commented_appointments_count", default: 0, null: false
    t.index ["deleted_at"], name: "index_admins_on_deleted_at"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["invitation_token"], name: "index_admins_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_admins_on_invitations_count"
    t.index ["invited_by_id"], name: "index_admins_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_admins_on_invited_by_type_and_invited_by_id"
    t.index ["is_active"], name: "index_admins_on_is_active"
    t.index ["is_super_admin"], name: "index_admins_on_is_super_admin"
    t.index ["name"], name: "index_admins_on_name"
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
    t.index ["unread_commented_appointments_count"], name: "index_admins_on_unread_commented_appointments_count"
  end

  create_table "app_versions", force: :cascade do |t|
    t.string "android_version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ios_version"
  end

  create_table "appointments", force: :cascade do |t|
    t.bigint "admin_id"
    t.bigint "user_id"
    t.string "bookable_type"
    t.bigint "bookable_id"
    t.bigint "vet_id"
    t.bigint "calendar_id"
    t.integer "main_appointment_id"
    t.string "comment"
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer "status"
    t.integer "total_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "number_of_days", default: 1
    t.text "dates", default: [], array: true
    t.boolean "is_viewed", default: false
    t.integer "comments_count", default: 0
    t.integer "unread_comments_count_by_user", default: 0, null: false
    t.integer "unread_comments_count_by_admin", default: 0, null: false
    t.index ["admin_id"], name: "index_appointments_on_admin_id"
    t.index ["bookable_type", "bookable_id"], name: "index_appointments_on_bookable_type_and_bookable_id"
    t.index ["calendar_id"], name: "index_appointments_on_calendar_id"
    t.index ["created_at"], name: "index_appointments_on_created_at"
    t.index ["deleted_at"], name: "index_appointments_on_deleted_at"
    t.index ["end_at"], name: "index_appointments_on_end_at"
    t.index ["main_appointment_id"], name: "index_appointments_on_main_appointment_id"
    t.index ["start_at"], name: "index_appointments_on_start_at"
    t.index ["status"], name: "index_appointments_on_status"
    t.index ["total_price"], name: "index_appointments_on_total_price"
    t.index ["unread_comments_count_by_admin"], name: "index_appointments_on_unread_comments_count_by_admin"
    t.index ["unread_comments_count_by_user"], name: "index_appointments_on_unread_comments_count_by_user"
    t.index ["user_id"], name: "index_appointments_on_user_id"
    t.index ["vet_id"], name: "index_appointments_on_vet_id"
  end

  create_table "appointments_pets", id: false, force: :cascade do |t|
    t.bigint "appointment_id", null: false
    t.bigint "pet_id", null: false
  end

  create_table "blocked_times", force: :cascade do |t|
    t.string "blockable_type"
    t.bigint "blockable_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blockable_type", "blockable_id"], name: "index_blocked_times_on_blockable_type_and_blockable_id"
    t.index ["end_at"], name: "index_blocked_times_on_end_at"
    t.index ["start_at"], name: "index_blocked_times_on_start_at"
  end

  create_table "boardings", force: :cascade do |t|
    t.bigint "admin_id"
    t.string "name"
    t.string "email"
    t.string "picture"
    t.string "mobile_number"
    t.string "website"
    t.text "description"
    t.boolean "is_active", default: true
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_boardings_on_admin_id"
    t.index ["deleted_at"], name: "index_boardings_on_deleted_at"
    t.index ["email"], name: "index_boardings_on_email"
    t.index ["is_active"], name: "index_boardings_on_is_active"
    t.index ["mobile_number"], name: "index_boardings_on_mobile_number"
    t.index ["name"], name: "index_boardings_on_name"
  end

  create_table "boardings_service_options", id: false, force: :cascade do |t|
    t.bigint "boarding_id", null: false
    t.bigint "service_option_id", null: false
  end

  create_table "breeds", force: :cascade do |t|
    t.string "name"
    t.bigint "pet_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pet_type_id"], name: "index_breeds_on_pet_type_id"
  end

  create_table "calendars", force: :cascade do |t|
    t.bigint "vet_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["end_at"], name: "index_calendars_on_end_at"
    t.index ["start_at"], name: "index_calendars_on_start_at"
    t.index ["vet_id"], name: "index_calendars_on_vet_id"
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "pet_id"
    t.bigint "appointment_id"
    t.string "serviceable_type"
    t.bigint "serviceable_id"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity", default: 1
    t.integer "total_price"
    t.bigint "service_option_time_id"
    t.index ["appointment_id"], name: "index_cart_items_on_appointment_id"
    t.index ["pet_id"], name: "index_cart_items_on_pet_id"
    t.index ["service_option_time_id"], name: "index_cart_items_on_service_option_time_id"
    t.index ["serviceable_type", "serviceable_id"], name: "index_cart_items_on_serviceable_type_and_serviceable_id"
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "clinics", force: :cascade do |t|
    t.bigint "admin_id"
    t.string "name"
    t.string "email"
    t.string "picture"
    t.string "mobile_number"
    t.integer "consultation_fee"
    t.string "website"
    t.text "description"
    t.boolean "is_active", default: true
    t.boolean "is_emergency", default: false
    t.integer "vets_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["admin_id"], name: "index_clinics_on_admin_id"
    t.index ["deleted_at"], name: "index_clinics_on_deleted_at"
    t.index ["email"], name: "index_clinics_on_email"
    t.index ["is_active"], name: "index_clinics_on_is_active"
    t.index ["is_emergency"], name: "index_clinics_on_is_emergency"
    t.index ["mobile_number"], name: "index_clinics_on_mobile_number"
    t.index ["name"], name: "index_clinics_on_name"
    t.index ["vets_count"], name: "index_clinics_on_vets_count"
  end

  create_table "clinics_pet_types", id: false, force: :cascade do |t|
    t.bigint "clinic_id", null: false
    t.bigint "pet_type_id", null: false
  end

  create_table "clinics_specializations", id: false, force: :cascade do |t|
    t.bigint "clinic_id", null: false
    t.bigint "specialization_id", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.string "writable_type"
    t.bigint "writable_id"
    t.datetime "read_at"
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["deleted_at"], name: "index_comments_on_deleted_at"
    t.index ["read_at"], name: "index_comments_on_read_at"
    t.index ["writable_type", "writable_id"], name: "index_comments_on_writable_type_and_writable_id"
  end

  create_table "contact_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.string "email"
    t.string "subject"
    t.string "message"
    t.boolean "is_answered", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_name"
    t.boolean "is_viewed", default: false
    t.index ["email"], name: "index_contact_requests_on_email"
    t.index ["is_answered"], name: "index_contact_requests_on_is_answered"
    t.index ["user_id"], name: "index_contact_requests_on_user_id"
  end

  create_table "day_care_centres", force: :cascade do |t|
    t.bigint "admin_id"
    t.string "name"
    t.string "email"
    t.string "picture"
    t.string "mobile_number"
    t.string "website"
    t.text "description"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["admin_id"], name: "index_day_care_centres_on_admin_id"
    t.index ["deleted_at"], name: "index_day_care_centres_on_deleted_at"
    t.index ["email"], name: "index_day_care_centres_on_email"
    t.index ["is_active"], name: "index_day_care_centres_on_is_active"
    t.index ["mobile_number"], name: "index_day_care_centres_on_mobile_number"
    t.index ["name"], name: "index_day_care_centres_on_name"
  end

  create_table "diagnoses", force: :cascade do |t|
    t.bigint "appointment_id"
    t.text "message"
    t.string "condition"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "pet_id"
    t.index ["appointment_id"], name: "index_diagnoses_on_appointment_id"
    t.index ["pet_id"], name: "index_diagnoses_on_pet_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id"
    t.string "favoritable_type"
    t.bigint "favoritable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["favoritable_type", "favoritable_id"], name: "index_favorites_on_favoritable_type_and_favoritable_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "grooming_centres", force: :cascade do |t|
    t.bigint "admin_id"
    t.string "name"
    t.string "email"
    t.string "mobile_number"
    t.string "picture"
    t.string "website"
    t.text "description"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["admin_id"], name: "index_grooming_centres_on_admin_id"
    t.index ["deleted_at"], name: "index_grooming_centres_on_deleted_at"
    t.index ["email"], name: "index_grooming_centres_on_email"
    t.index ["is_active"], name: "index_grooming_centres_on_is_active"
    t.index ["mobile_number"], name: "index_grooming_centres_on_mobile_number"
    t.index ["name"], name: "index_grooming_centres_on_name"
  end

  create_table "item_brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture"
    t.float "brand_discount"
  end

  create_table "item_brands_categories", id: false, force: :cascade do |t|
    t.bigint "item_category_id", null: false
    t.bigint "item_brand_id", null: false
  end

  create_table "item_categories", force: :cascade do |t|
    t.string "name"
    t.string "picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "IsHaveBrand"
  end

  create_table "item_categories_pet_types", id: false, force: :cascade do |t|
    t.bigint "pet_type_id", null: false
    t.bigint "item_category_id", null: false
  end

  create_table "item_reviews", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "item_id"
    t.integer "rating"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "order_item_id"
    t.index ["item_id"], name: "index_item_reviews_on_item_id"
    t.index ["order_item_id"], name: "index_item_reviews_on_order_item_id"
    t.index ["user_id"], name: "index_item_reviews_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.float "discount"
    t.integer "weight"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unit"
    t.bigint "item_brand_id"
    t.string "picture"
    t.integer "rating"
    t.integer "review_count"
    t.bigint "item_categories_id"
    t.bigint "pet_type_id"
    t.integer "avg_rating"
    t.integer "quantity"
    t.string "short_description"
    t.float "unit_price"
    t.float "buying_price"
    t.index ["item_brand_id"], name: "index_items_on_item_brands_id"
    t.index ["item_categories_id"], name: "index_items_on_item_categories_id"
    t.index ["pet_type_id"], name: "index_items_on_pet_type_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "place_type"
    t.bigint "place_id"
    t.float "latitude"
    t.float "longitude"
    t.string "city"
    t.string "area"
    t.string "street"
    t.integer "building_type"
    t.string "building_name"
    t.string "unit_number"
    t.string "villa_number"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["city"], name: "index_locations_on_city"
    t.index ["deleted_at"], name: "index_locations_on_deleted_at"
    t.index ["place_type", "place_id"], name: "index_locations_on_place_type_and_place_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "admin_id"
    t.bigint "user_id"
    t.bigint "appointment_id"
    t.bigint "pet_id"
    t.string "message"
    t.boolean "skip_push_sending", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "viewed_at"
    t.boolean "is_for_vaccine", default: false
    t.index ["admin_id"], name: "index_notifications_on_admin_id"
    t.index ["appointment_id"], name: "index_notifications_on_appointment_id"
    t.index ["pet_id"], name: "index_notifications_on_pet_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
    t.index ["viewed_at"], name: "index_notifications_on_viewed_at"
  end

# Could not dump table "order_items" because of following StandardError
#   Unknown type 'order_item_status' for column 'status'

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "location_id"
    t.datetime "Delivery_Date"
    t.string "Order_Notes"
    t.float "Subtotal"
    t.float "Delivery_Charges"
    t.float "Vat_Charges"
    t.float "Total"
    t.boolean "IsCash"
    t.integer "Order_Status"
    t.integer "Payment_Status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "shipmenttime"
    t.integer "RedeemPoints"
    t.string "TransactionId"
    t.datetime "TransactionDate"
    t.integer "earned_points"
    t.index ["location_id"], name: "index_orders_on_location_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "pet_types", force: :cascade do |t|
    t.string "name"
    t.boolean "is_additional_type", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture"
    t.boolean "IsHaveCategories"
  end

  create_table "pet_types_trainers", id: false, force: :cascade do |t|
    t.bigint "pet_type_id", null: false
    t.bigint "trainer_id", null: false
  end

  create_table "pet_types_vaccine_types", id: false, force: :cascade do |t|
    t.bigint "pet_type_id", null: false
    t.bigint "vaccine_type_id", null: false
  end

  create_table "pet_types_vets", id: false, force: :cascade do |t|
    t.bigint "pet_type_id", null: false
    t.bigint "vet_id", null: false
  end

  create_table "pets", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "breed_id"
    t.bigint "pet_type_id"
    t.string "additional_type"
    t.string "name"
    t.datetime "birthday"
    t.integer "sex"
    t.float "weight"
    t.string "comment"
    t.string "avatar"
    t.datetime "lost_at"
    t.datetime "found_at"
    t.boolean "is_for_adoption", default: false
    t.string "description"
    t.string "mobile_number"
    t.string "additional_comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "microchip"
    t.string "municipality_tag"
    t.index ["breed_id"], name: "index_pets_on_breed_id"
    t.index ["deleted_at"], name: "index_pets_on_deleted_at"
    t.index ["found_at"], name: "index_pets_on_found_at"
    t.index ["is_for_adoption"], name: "index_pets_on_is_for_adoption"
    t.index ["lost_at"], name: "index_pets_on_lost_at"
    t.index ["pet_type_id"], name: "index_pets_on_pet_type_id"
    t.index ["user_id"], name: "index_pets_on_user_id"
  end

  create_table "pictures", force: :cascade do |t|
    t.string "attachment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picturable_type"
    t.bigint "picturable_id"
    t.index ["picturable_type", "picturable_id"], name: "index_pictures_on_picturable_type_and_picturable_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title"
    t.text "message"
    t.integer "comments_count", default: 0
    t.bigint "pet_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_posts_on_deleted_at"
    t.index ["pet_type_id"], name: "index_posts_on_pet_type_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "qualifications", force: :cascade do |t|
    t.string "skill_type"
    t.bigint "skill_id"
    t.string "diploma"
    t.string "university"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skill_type", "skill_id"], name: "index_qualifications_on_skill_type_and_skill_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.text "instruction"
    t.bigint "diagnosis_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["diagnosis_id"], name: "index_recipes_on_diagnosis_id"
  end

  create_table "recurssion_intervals", force: :cascade do |t|
    t.integer "weeks"
    t.integer "days"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "label"
  end

  create_table "redeem_points", force: :cascade do |t|
    t.integer "net_worth"
    t.integer "last_net_worth"
    t.string "last_reward_type"
    t.integer "last_reward_worth"
    t.datetime "last_reward_update"
    t.datetime "last_net_update"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "totalearnedpoints"
    t.integer "totalavailedpoints"
    t.index ["user_id"], name: "index_redeem_points_on_user_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.string "schedulable_type"
    t.bigint "schedulable_id"
    t.boolean "day_and_night", default: false
    t.datetime "monday_open_at"
    t.datetime "monday_close_at"
    t.datetime "tuesday_open_at"
    t.datetime "tuesday_close_at"
    t.datetime "wednesday_open_at"
    t.datetime "wednesday_close_at"
    t.datetime "thursday_open_at"
    t.datetime "thursday_close_at"
    t.datetime "friday_open_at"
    t.datetime "friday_close_at"
    t.datetime "saturday_open_at"
    t.datetime "saturday_close_at"
    t.datetime "sunday_open_at"
    t.datetime "sunday_close_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_schedules_on_deleted_at"
    t.index ["schedulable_type", "schedulable_id"], name: "index_schedules_on_schedulable_type_and_schedulable_id"
  end

  create_table "service_details", force: :cascade do |t|
    t.bigint "service_type_id"
    t.bigint "pet_type_id"
    t.float "weight"
    t.float "total_space"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.float "min_weight", default: 0.0
    t.index ["deleted_at"], name: "index_service_details_on_deleted_at"
    t.index ["pet_type_id"], name: "index_service_details_on_pet_type_id"
    t.index ["service_type_id"], name: "index_service_details_on_service_type_id"
  end

  create_table "service_option_details", force: :cascade do |t|
    t.bigint "service_option_id"
    t.string "service_optionable_type"
    t.bigint "service_optionable_id"
    t.datetime "deleted_at"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_service_option_details_on_deleted_at"
    t.index ["service_option_id"], name: "index_service_option_details_on_service_option_id"
    t.index ["service_optionable_type", "service_optionable_id"], name: "index_service_and_option"
  end

  create_table "service_option_times", force: :cascade do |t|
    t.bigint "service_option_detail_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_option_detail_id"], name: "index_service_option_times_on_service_option_detail_id"
  end

  create_table "service_options", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_types", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "serviceable_type"
    t.bigint "serviceable_id"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_service_types_on_deleted_at"
    t.index ["is_active"], name: "index_service_types_on_is_active"
    t.index ["serviceable_type", "serviceable_id"], name: "index_service_types_on_serviceable_type_and_serviceable_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "token"
    t.string "device_type"
    t.string "device_id"
    t.string "push_token"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_sessions_on_token", unique: true
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "shopping_cart_items", force: :cascade do |t|
    t.boolean "IsRecurring"
    t.integer "Interval"
    t.integer "quantity"
    t.bigint "item_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "recurssion_interval_id"
    t.index ["item_id"], name: "index_shopping_cart_items_on_item_id"
    t.index ["recurssion_interval_id"], name: "index_shopping_cart_items_on_recurssion_intervals_id"
    t.index ["user_id"], name: "index_shopping_cart_items_on_user_id"
  end

  create_table "specializations", force: :cascade do |t|
    t.string "name"
    t.boolean "is_for_trainer", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_for_trainer"], name: "index_specializations_on_is_for_trainer"
  end

  create_table "specializations_trainers", id: false, force: :cascade do |t|
    t.bigint "specialization_id", null: false
    t.bigint "trainer_id", null: false
  end

  create_table "specializations_vets", id: false, force: :cascade do |t|
    t.bigint "specialization_id", null: false
    t.bigint "vet_id", null: false
  end

  create_table "terms_and_conditions", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trainers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "picture"
    t.string "mobile_number"
    t.boolean "is_active", default: true
    t.integer "experience"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_trainers_on_deleted_at"
    t.index ["email"], name: "index_trainers_on_email"
    t.index ["experience"], name: "index_trainers_on_experience"
    t.index ["is_active"], name: "index_trainers_on_is_active"
    t.index ["mobile_number"], name: "index_trainers_on_mobile_number"
    t.index ["name"], name: "index_trainers_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "mobile_number"
    t.string "encrypted_password", default: "", null: false
    t.string "facebook_id"
    t.string "google_id"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer "sign_in_count", default: 0, null: false
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "gender"
    t.datetime "birthday"
    t.integer "notifications_count", default: 0
    t.integer "commented_appointments_count", default: 0, null: false
    t.integer "unread_commented_appointments_count", default: 0, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["facebook_id"], name: "index_users_on_facebook_id", unique: true
    t.index ["google_id"], name: "index_users_on_google_id", unique: true
    t.index ["is_active"], name: "index_users_on_is_active"
    t.index ["mobile_number"], name: "index_users_on_mobile_number"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unread_commented_appointments_count"], name: "index_users_on_unread_commented_appointments_count"
  end

  create_table "vaccinations", force: :cascade do |t|
    t.bigint "vaccine_type_id"
    t.bigint "pet_id"
    t.datetime "done_at"
    t.string "picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["done_at"], name: "index_vaccinations_on_done_at"
    t.index ["pet_id"], name: "index_vaccinations_on_pet_id"
    t.index ["vaccine_type_id"], name: "index_vaccinations_on_vaccine_type_id"
  end

  create_table "vaccine_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "vets", force: :cascade do |t|
    t.bigint "clinic_id"
    t.string "name"
    t.string "email"
    t.string "mobile_number"
    t.string "avatar"
    t.boolean "is_active", default: true
    t.boolean "is_emergency", default: false
    t.boolean "use_clinic_location", default: false
    t.integer "consultation_fee"
    t.integer "experience"
    t.integer "session_duration", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["clinic_id"], name: "index_vets_on_clinic_id"
    t.index ["deleted_at"], name: "index_vets_on_deleted_at"
    t.index ["email"], name: "index_vets_on_email"
    t.index ["experience"], name: "index_vets_on_experience"
    t.index ["is_active"], name: "index_vets_on_is_active"
    t.index ["is_emergency"], name: "index_vets_on_is_emergency"
    t.index ["mobile_number"], name: "index_vets_on_mobile_number"
    t.index ["name"], name: "index_vets_on_name"
  end

  create_table "wishlists", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_wishlists_on_item_id"
    t.index ["user_id"], name: "index_wishlists_on_user_id"
  end

  add_foreign_key "appointments", "admins"
  add_foreign_key "appointments", "calendars"
  add_foreign_key "appointments", "users"
  add_foreign_key "appointments", "vets"
  add_foreign_key "boardings", "admins"
  add_foreign_key "breeds", "pet_types"
  add_foreign_key "calendars", "vets"
  add_foreign_key "cart_items", "appointments"
  add_foreign_key "cart_items", "pets"
  add_foreign_key "cart_items", "service_option_times"
  add_foreign_key "clinics", "admins"
  add_foreign_key "contact_requests", "users"
  add_foreign_key "day_care_centres", "admins"
  add_foreign_key "diagnoses", "appointments"
  add_foreign_key "diagnoses", "pets"
  add_foreign_key "favorites", "users"
  add_foreign_key "grooming_centres", "admins"
  add_foreign_key "item_reviews", "items"
  add_foreign_key "item_reviews", "order_items"
  add_foreign_key "item_reviews", "users"
  add_foreign_key "items", "item_brands"
  add_foreign_key "items", "item_categories", column: "item_categories_id"
  add_foreign_key "items", "pet_types"
  add_foreign_key "notifications", "admins"
  add_foreign_key "notifications", "appointments"
  add_foreign_key "notifications", "pets"
  add_foreign_key "notifications", "users"
  add_foreign_key "order_items", "items"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "recurssion_intervals"
  add_foreign_key "orders", "locations"
  add_foreign_key "orders", "users"
  add_foreign_key "pets", "breeds"
  add_foreign_key "pets", "pet_types"
  add_foreign_key "pets", "users"
  add_foreign_key "posts", "pet_types"
  add_foreign_key "posts", "users"
  add_foreign_key "recipes", "diagnoses"
  add_foreign_key "redeem_points", "users"
  add_foreign_key "service_details", "pet_types"
  add_foreign_key "service_details", "service_types"
  add_foreign_key "service_option_details", "service_options"
  add_foreign_key "service_option_times", "service_option_details"
  add_foreign_key "sessions", "users"
  add_foreign_key "shopping_cart_items", "items"
  add_foreign_key "shopping_cart_items", "recurssion_intervals"
  add_foreign_key "shopping_cart_items", "users"
  add_foreign_key "vaccinations", "pets"
  add_foreign_key "vaccinations", "vaccine_types"
  add_foreign_key "vets", "clinics"
  add_foreign_key "wishlists", "items"
  add_foreign_key "wishlists", "users"
end
