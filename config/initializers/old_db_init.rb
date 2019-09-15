# frozen_string_literal: true

Sequel::Model.plugin :touch
Old_DB.convert_tinyint_to_bool = false

class OldUser < Sequel::Model(Old_DB[:users])
  one_to_many :chat_rooms_members, class: :OldChatRoomMember, key: :user_id
  many_to_many :chat_rooms, left_key: :user_id, right_key: :chat_room_id,
  join_table: :chat_rooms_members
end
class OldChatRoom < Sequel::Model(Old_DB[:chat_rooms])
  many_to_many :users, left_key: :chat_room_id, right_key: :user_id,
  join_table: :chat_rooms_members
  one_to_many :chat_rooms_members, class: :OldChatRoomMember, key: :chat_room_id
end
class OldChatRoomMember < Sequel::Model(Old_DB[:chat_rooms_members])
  many_to_one :user, class: :OldUser
  many_to_one :chat_room, class: :OldChatRoom
end
class OldRelation < Sequel::Model(Old_DB[:supervises]); end
class OldTodo < Sequel::Model(Old_DB[:todos]); end
class OldDepartment < Sequel::Model(Old_DB[:departments])
  many_to_one :m_faculty, class: :OldFaculty
end
class OldFaculty < Sequel::Model(Old_DB[:faculties])
  one_to_many :departments, class: :OldDepartment, key: :faculty
  many_to_one :m_university, class: :OldUniversity
end
class OldUniversity < Sequel::Model(Old_DB[:universities])
  one_to_many :faculties, class: :OldFaculty, key: :university
end

OldUser.plugin :timestamps, create: :date_created, update: :date_modified, update_on_create: true
OldUser.plugin :touch, column: :date_modified
OldChatRoom.plugin :timestamps, create: :date_created, update: :date_modified, update_on_create: true
OldChatRoom.plugin :touch, column: :date_modified
OldChatRoomMember.plugin :timestamps, create: :date_created, update: :date_modified, update_on_create: true
OldChatRoomMember.plugin :touch, column: :date_modified
OldRelation.plugin :timestamps, create: :date_created, update: :date_modified, update_on_create: true
OldRelation.plugin :touch, column: :date_modified
OldTodo.plugin :timestamps, create: :date_created, update: :date_modified, update_on_create: true
OldTodo.plugin :touch, column: :date_modified
OldDepartment.plugin :timestamps, create: :date_created, update: :date_modified, update_on_create: true
OldDepartment.plugin :touch, column: :date_modified
OldFaculty.plugin :timestamps, create: :date_created, update: :date_modified, update_on_create: true
OldFaculty.plugin :touch, column: :date_modified
OldUniversity.plugin :timestamps, create: :date_created, update: :date_modified, update_on_create: true
OldUniversity.plugin :touch, column: :date_modified

class OldDbSyncTask
  include Delayed::RecurringJob
  run_every 2.minute
  queue 'slow_jobs'
  def perform
    OldDb.sync
  end
end

Rails.configuration.after_initialize do
  OldDbSyncTask.schedule!
end
