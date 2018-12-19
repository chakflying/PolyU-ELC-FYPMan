class OldUsers < Sequel::Model(Old_DB[:users]); end
class OldDepartments < Sequel::Model(Old_DB[:departments]); end
class OldRelations < Sequel::Model(Old_DB[:supervises]); end
class OldTodos < Sequel::Model(Old_DB[:todos]); end

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