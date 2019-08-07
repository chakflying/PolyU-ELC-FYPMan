# frozen_string_literal: true

class SyncRecordDatatable < AjaxDatatablesRails::ActiveRecord
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: 'SyncRecord.id', cond: :eq },
      started_at: { source: 'SyncRecord.started_at' },
      ended_at: { source: 'SyncRecord.ended_at' },
      duration: { searchable: false },
      num_errors: { source: 'SyncRecord.num_errors' },
      errors_text: { source: 'SyncRecord.errors_text' }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        started_at: record.started_at,
        ended_at: record.ended_at,
        duration: ChronicDuration.output(record.ended_at - record.started_at, :format => :short),
        num_errors: record.num_errors,
        errors_text: record.errors_text
      }
    end
  end

  def get_raw_records
    SyncRecord.all
  end
end
