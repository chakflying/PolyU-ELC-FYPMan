module AdminHelper
  def check_sync_error
    if session[:sync_last_checked].blank?
      session[:sync_last_checked] = Time.now
    end
    if SyncRecord.where("num_errors > 0").order("created_at DESC").limit(1).last.ended_at > session[:sync_last_checked]
      flash.now[:danger] = Array(flash.now[:danger]).push('<i class="fas fa-exclamation-triangle"></i>&nbsp;&nbsp;You may want to check for Sync errors in Admin <i class="fas fa-arrow-right" style="font-size: 80%"></i> Sync Records.')
      session[:sync_last_checked] = Time.now
    end
  end
end