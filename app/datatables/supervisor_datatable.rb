# frozen_string_literal: true

class SupervisorDatatable < AjaxDatatablesRails::ActiveRecord
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: 'Supervisor.id', cond: :eq },
      name: { source: 'Supervisor.name' },
      netID: { source: 'Supervisor.netID' },
      department: { source: 'Department.code' },
      students: { source: 'Student.name' },
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
        students: students_list(record.students, record.netID).html_safe,
        dt_action: action_edit(record.id).html_safe,
        DT_RowId: record.id
      }
    end
  end

  def students_list(students, sup_netID)
    out = '<div>'
    students.each do |student|
      out += format('<div class="row dt-rel-row"><div class="col-lg-7 col-sm-6" style="overflow:hidden;">%s</div><div class="col-lg-3 col-sm-4">%s</div><div class="col-sm-2"><a rel="nofollow" data-method="post" href="/removeStudent?stu_netID=%s&amp;sup_netID=%s"><button class="btn btn-sm btn-light dt-btn-rm" aria-label="Remove Student">remove</button></a></div></div>', student.netID, student.fyp_year, CGI.escape(student.netID), CGI.escape(sup_netID))
    end
    out += '</div>'
    out
  end

  def action_edit(id)
    format('<a data-method="get" href="/supervisors/%s/edit"><button class="btn btn-sm btn-secondary dt-btn" aria-label="Edit Supervisor"><i class="fas fa-user-edit"></i></button></a>', id)
  end

  def get_raw_records
    if options[:admin]
      Supervisor.all.includes(:department, :students).references(:department, :students)
    else
      Supervisor.where(department: options[:current_user_department]).includes(:department, :students).references(:department, :students)
    end
  end
end
