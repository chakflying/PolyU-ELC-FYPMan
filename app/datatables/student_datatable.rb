# frozen_string_literal: true

class StudentDatatable < AjaxDatatablesRails::ActiveRecord
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: 'Student.id', cond: :eq },
      name: { source: 'Student.name' },
      netID: { source: 'Student.netID' },
      department: { source: 'Department.code' },
      fyp_year: { source: 'Student.fyp_year' },
      supervisors: { source: 'Supervisor.name' },
      dt_action: { searchable: false }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        name: record.name,
        netID: record.netID,
        department: (record.department.present? ? record.department.code : ''),
        fyp_year: record.fyp_year,
        supervisors: supervisors_list(record.supervisors, record.netID).html_safe,
        dt_action: action_edit(record.id).html_safe,
        DT_RowId: record.id
      }
    end
  end

  def supervisors_list(supervisors, stu_netID)
    out = '<div class="dt-rel">'
    supervisors.each do |supervisor|
      out += format('<div class="row dt-rel-row"><div class="col-sm-9 dt-rel-name">%s</div><div class="col-sm-3"><a rel="nofollow" data-method="post" href="/removeSupervisor?stu_netID=%s&amp;sup_netID=%s"><button class="btn btn-sm btn-light dt-btn-rm" aria-label="Remove Supervisor">remove</button></a></div></div>', supervisor.name, CGI.escape(stu_netID), CGI.escape(supervisor.netID))
    end
    out += '</div>'
    out
  end

  def action_edit(id)
    format('<a data-method="get" href="/students/%s/edit"><button class="btn btn-sm btn-secondary dt-btn" aria-label="Edit Student"><i class="fas fa-user-edit"></i></button></a>', id)
  end

  def get_raw_records
    if options[:admin]
      Student.all.includes(:department, :supervisors).references(:department, :supervisors)
    else
      Student.where(department: options[:current_user_department]).includes(:department, :supervisors).references(:department, :supervisors)
    end
  end
end
