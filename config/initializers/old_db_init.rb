class OldUsers < Sequel::Model(Old_DB[:users]); end
class OldDepartments < Sequel::Model(Old_DB[:departments]); end
class OldRelations < Sequel::Model(Old_DB[:supervises]); end
class OldTodos < Sequel::Model(Old_DB[:todos]); end

OldUsers.plugin :timestamps, create: :date_created, update: :date_modified
OldRelations.plugin :timestamps, create: :date_created, update: :date_modified
OldTodos.plugin :timestamps, create: :date_created, update: :date_modified

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