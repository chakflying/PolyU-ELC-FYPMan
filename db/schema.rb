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

ActiveRecord::Schema.define(version: 2019_03_09_170252) do

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
    t.string "code", limit: 8
    t.integer "sync_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "university_id"
    t.index ["sync_id"], name: "index_faculties_on_sync_id"
    t.index ["university_id"], name: "index_faculties_on_university_id"
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

  create_table "students_supervisors", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "supervisor_id", null: false
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
    t.string "code", limit: 8
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

  create_table "versions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "item_type", limit: 191, null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", limit: 4294967295
    t.datetime "created_at"
    t.text "object_changes", limit: 4294967295
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
