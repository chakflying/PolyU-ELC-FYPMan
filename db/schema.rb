# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_07_172749) do

  create_table "delayed_jobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "departments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "faculty_id"
    t.integer "sync_id"
    t.index ["faculty_id"], name: "index_departments_on_faculty_id"
    t.index ["sync_id"], name: "index_departments_on_sync_id"
  end

  create_table "faculties", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "code"
    t.integer "sync_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "university_id"
    t.index ["sync_id"], name: "index_faculties_on_sync_id"
    t.index ["university_id"], name: "index_faculties_on_university_id"
  end

  create_table "groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "sync_id"
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sync_id"], name: "index_groups_on_sync_id"
  end

  create_table "groups_students", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_groups_students_on_group_id"
    t.index ["student_id"], name: "index_groups_students_on_student_id"
  end

  create_table "groups_supervisors", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "supervisor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_groups_supervisors_on_group_id"
    t.index ["supervisor_id"], name: "index_groups_supervisors_on_supervisor_id"
  end

  create_table "students", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "netID", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fyp_year"
    t.integer "sync_id"
    t.bigint "department_id"
    t.index ["department_id"], name: "index_students_on_department_id"
    t.index ["sync_id"], name: "index_students_on_sync_id"
  end

  create_table "supervisions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "supervisor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_supervisions_on_student_id"
    t.index ["supervisor_id"], name: "index_supervisions_on_supervisor_id"
  end

  create_table "supervisors", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "netID", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sync_id"
    t.bigint "department_id"
    t.index ["department_id"], name: "index_supervisors_on_department_id"
    t.index ["sync_id"], name: "index_supervisors_on_sync_id"
  end

  create_table "sync_records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer "num_errors"
    t.text "errors_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "todos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.datetime "eta"
    t.integer "sync_id"
    t.bigint "department_id"
    t.string "color", limit: 10, default: "danger"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_todos_on_department_id"
    t.index ["sync_id"], name: "index_todos_on_sync_id"
  end

  create_table "universities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "code"
    t.integer "sync_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sync_id"], name: "index_universities_on_sync_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.datetime "last_seen_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.bigint "department_id"
    t.index ["department_id"], name: "index_users_on_department_id"
  end

  create_table "version_associations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "version_id"
    t.string "foreign_key_name", null: false
    t.integer "foreign_key_id"
    t.string "foreign_type"
    t.index ["foreign_key_name", "foreign_key_id", "foreign_type"], name: "index_version_associations_on_foreign_key"
    t.index ["version_id"], name: "index_version_associations_on_version_id"
  end

  create_table "versions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "item_type", limit: 191, null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", size: :long
    t.datetime "created_at"
    t.text "object_changes", size: :long
    t.integer "transaction_id"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["transaction_id"], name: "index_versions_on_transaction_id"
  end

  add_foreign_key "groups_students", "groups"
  add_foreign_key "groups_students", "students"
  add_foreign_key "groups_supervisors", "groups"
  add_foreign_key "groups_supervisors", "supervisors"
end
