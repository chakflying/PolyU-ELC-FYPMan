class OldDbSyncTask
    include Delayed::RecurringJob
    run_every 1.minute
    queue 'slow-jobs'
    def perform
      OldDb.sync
    end
end

Rails.configuration.after_initialize do
    OldDbSyncTask.schedule!
  end