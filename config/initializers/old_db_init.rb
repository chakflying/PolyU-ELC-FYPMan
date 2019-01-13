class OldUsers < Sequel::Model(Old_DB[:users]); end
class OldDepartments < Sequel::Model(Old_DB[:departments]); end
class OldRelations < Sequel::Model(Old_DB[:supervises]); end
class OldTodos < Sequel::Model(Old_DB[:todos]); end
class OldFaculties < Sequel::Model(Old_DB[:faculties]); end
class OldUniversities < Sequel::Model(Old_DB[:universities]); end

OldUsers.plugin :timestamps, create: :date_created, update: :date_modified
OldRelations.plugin :timestamps, create: :date_created, update: :date_modified
OldTodos.plugin :timestamps, create: :date_created, update: :date_modified
OldDepartments.plugin :timestamps, create: :date_created, update: :date_modified
OldFaculties.plugin :timestamps, create: :date_created, update: :date_modified
OldUniversities.plugin :timestamps, create: :date_created, update: :date_modified

class OldDbSyncTask
    include Delayed::RecurringJob
    run_every 5.minute
    queue 'slow-jobs'
    def perform
      OldDb.sync
    end
end

Rails.configuration.after_initialize do
    OldDbSyncTask.schedule!
  end