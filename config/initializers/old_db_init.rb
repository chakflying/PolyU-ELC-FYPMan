# frozen_string_literal: true

Sequel::Model.plugin :touch

class OldUser < Sequel::Model(Old_DB[:users])
  one_to_many :chat_room_members, class: :OldChatRoomMember
end
class OldChatRoom < Sequel::Model(Old_DB[:chat_rooms]); end
class OldChatRoomMember < Sequel::Model(Old_DB[:chat_rooms_members])
  many_to_one :user, key: :user_id, class: :OldUser
end
class OldRelation < Sequel::Model(Old_DB[:supervises]); end
class OldTodo < Sequel::Model(Old_DB[:todos]); end
class OldDepartment < Sequel::Model(Old_DB[:departments])
  many_to_one :m_faculty, key: :faculty, class: :OldFaculty
end
class OldFaculty < Sequel::Model(Old_DB[:faculties])
  one_to_many :departments, class: :OldDepartment
  many_to_one :m_university, key: :university, class: :OldUniversity
end
class OldUniversity < Sequel::Model(Old_DB[:universities])
  one_to_many :faculties, class: :OldFaculty
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
