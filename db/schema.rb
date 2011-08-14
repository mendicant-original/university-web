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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110811140835) do

  create_table "admissions_statuses", :force => true do |t|
    t.text     "name"
    t.integer  "sort_order"
    t.string   "hex_color"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "reviewable"
  end

  create_table "admissions_submissions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "status_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "alumni_preferences", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "show_on_public_site"
    t.boolean  "show_twitter"
    t.boolean  "show_github"
    t.boolean  "show_real_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "announcements", :force => true do |t|
    t.boolean  "public"
    t.string   "title"
    t.text     "body"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  create_table "assignment_activities", :force => true do |t|
    t.integer  "assignment_id"
    t.integer  "submission_id"
    t.integer  "user_id"
    t.text     "description"
    t.text     "actionable_type"
    t.integer  "actionable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "context"
  end

  create_table "assignment_reviews", :force => true do |t|
    t.integer  "comment_id"
    t.boolean  "closed",      :default => false, :null => false
    t.string   "type"
    t.integer  "assigned_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assignment_submissions", :force => true do |t|
    t.integer  "assignment_id"
    t.integer  "user_id"
    t.integer  "submission_status_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "github_repository"
    t.datetime "last_commit_time"
    t.string   "last_commit_id"
  end

  create_table "assignments", :force => true do |t|
    t.integer  "course_id"
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.text     "notes"
    t.string   "short_description"
    t.integer  "sort_order"
  end

  create_table "chat_channel_memberships", :force => true do |t|
    t.integer  "channel_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible_on_dashboard", :default => true
  end

  create_table "chat_channels", :force => true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "public"
  end

  create_table "chat_handles", :force => true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chat_messages", :force => true do |t|
    t.text     "body"
    t.datetime "recorded_at"
    t.integer  "handle_id"
    t.integer  "channel_id"
    t.integer  "topic_id"
    t.boolean  "action"
  end

  create_table "chat_topics", :force => true do |t|
    t.text     "name"
    t.integer  "channel_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.text     "comment_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "in_reply_to_id"
    t.integer  "index"
  end

  create_table "course_documents", :force => true do |t|
    t.integer  "document_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_instructor_associations", :force => true do |t|
    t.integer  "course_id"
    t.integer  "instructor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "access_level"
  end

  create_table "courses", :force => true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "channel_id"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "archived",              :default => false
    t.integer  "term_id"
    t.integer  "class_size_limit"
    t.text     "description"
    t.text     "notes"
    t.string   "cc_comments"
    t.boolean  "open_for_enrollment"
    t.date     "enrollment_close_date"
  end

  create_table "documents", :force => true do |t|
    t.text     "title"
    t.text     "body"
    t.boolean  "public_internal"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exam_submissions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "exam_id"
    t.integer  "submission_status_id"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exams", :force => true do |t|
    t.string   "name"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "term_id"
  end

  create_table "submission_statuses", :force => true do |t|
    t.text     "name"
    t.integer  "sort_order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "hex_color"
  end

  create_table "terms", :force => true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "year"
    t.integer  "number"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                   :default => "",   :null => false
    t.string   "encrypted_password",       :limit => 128, :default => "",   :null => false
    t.string   "password_salt",                           :default => "",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "requires_password_change",                :default => true
    t.string   "access_level"
    t.text     "real_name"
    t.text     "nickname"
    t.text     "twitter_account_name"
    t.text     "github_account_name"
    t.text     "project_url"
    t.integer  "alumni_number"
    t.integer  "alumni_month"
    t.integer  "alumni_year"
    t.string   "entrance_exam_url"
    t.string   "time_zone"
    t.string   "location"
    t.decimal  "latitude"
    t.decimal  "longitude"
  end

  create_table "waitlisted_students", :force => true do |t|
    t.integer  "term_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
