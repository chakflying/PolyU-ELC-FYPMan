class PaperTrail::VersionDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "PaperTrail::Version.id", cond: :eq },
      item_type: { source: "PaperTrail::Version.item_type" },
      event: { source: "PaperTrail::Version.event" },
      whodunnit: { source: "PaperTrail::Version.whodunnit" },
      created_at: { source: "PaperTrail::Version.created_at" },
      changeset: { source: "PaperTrail::Version.object_changes" }
    }
  end

  def data
    records.map do |record|
      {
        id:         record.id,
        item_type: record.item_type,
        event:  record.event,
        whodunnit:      (record.whodunnit ? User.find(record.whodunnit).username : ""),
        created_at:        record.created_at.in_time_zone("Hong Kong").strftime("%Y-%m-%d %I:%M%p"),
        changeset:        record.changeset.except(:updated_at, :created_at),
        DT_RowId:   record.id,
      }
    end
  end

  def get_raw_records
    if options[:item_type].blank?
      PaperTrail::Version.all
    else
      PaperTrail::Version.where(item_type: options[:item_type])
    end
  end

end
