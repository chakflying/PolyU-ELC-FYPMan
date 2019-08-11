# frozen_string_literal: true

class GroupDatatable < AjaxDatatablesRails::ActiveRecord
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      number: { source: 'Group.number', cond: :eq },
      students: { source: 'Student.netID' },
      supervisors: { source: 'Supervisor.netID' },
      dt_action: { searchable: false }
    }
  end

  def data
    records.map do |record|
      {
        number: record.number,
        students: students_list(record.students, record.id).html_safe,
        supervisors: supervisors_list(record.supervisors, record.id).html_safe,
        dt_action: action_edit(record.id).html_safe + action_add_mem(record.id).html_safe,
        DT_RowId: record.id
      }
    end
  end

  def students_list(students, group_id)
    out = '<div class="dt-gp-mem">'
    students.each do |student|
      out += format('<div class="row dt-gp-mem-row"><div class="col-xs-10 col-sm-9 col-md-5 col-lg-5 col-xl-5 col-8" style="overflow:hidden;">%s</div><div class="col-lg-4 col-xl-4 col-3 d-none d-md-block">%s</div><div class="col-1 d-none d-lg-block">%s</div><div class="col-1"><button class="btn btn-sm btn-light dt-btn-gp-rm-stu" data-stu_id="%d" data-gp_id="%d" aria-label="Remove Student" data-toggle="tooltip" data-placement="right" title="Remove Student"><i class="fas fa-user-slash"></i></button></div></div>', CGI.escapeHTML(student.netID), (student.name.present? ? CGI.escapeHTML(student.name) : ''), (student.department.present? ? student.department.code : ''), student.id, group_id)
    end
    out += '</div>'
    out
  end

  def supervisors_list(supervisors, group_id)
    out = '<div class="dt-gp-sup">'
    supervisors.each do |supervisor|
      out += format('<div class="row dt-gp-mem-row"><div class="col-xs-10 col-sm-9 col-md-5 col-lg-5 col-xl-5 col-8" style="overflow:hidden;">%s</div><div class="col-lg-4 col-xl-4 col-3 d-none d-md-block">%s</div><div class="col-1 d-none d-lg-block">%s</div><div class="col-1"><button class="btn btn-sm btn-light dt-btn-gp-rm-sup" data-sup_id="%d" data-gp_id="%d" aria-label="Remove Supervisor" data-toggle="tooltip" data-placement="right" title="Remove Supervisor"><i class="fas fa-user-slash"></i></button></div></div>', CGI.escapeHTML(supervisor.netID), (supervisor.name.present? ? CGI.escapeHTML(supervisor.name) : ''), (supervisor.department.present? ? supervisor.department.code : ''), supervisor.id, group_id)
    end
    out += '</div>'
    out
  end

  def action_edit(id)
    format('<button class="btn btn-sm btn-danger dt-btn dt-btn-gp-rm" aria-label="Remove Group" data-toggle="tooltip" data-placement="right" title="Remove Group" data-id="%s"><i class="fas fa-trash"></i></button>', id)
  end

  def action_add_mem(id)
    template = format('<div class="dropleft">
                  <button class="btn btn-sm btn-secondary dt-btn" style="margin-top:0.4em" type="button" id="addgpmembtn" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" data-gp_id="%d">
                    <i class="fas fa-user-plus"></i>
                  </button>
                  <div class="dropdown-menu" aria-labelledby="addgpmembtn">
                    <a class="dropdown-item" href="#" id="addgpmem-vue%d">Action</a>
                  </div>
                </div>', id, id)
    template
  end

  def get_raw_records
    if options[:admin]
      Group.all.includes(students: :department, supervisors: :department).references(:students, :supervisors)
    else
      Group.where(students: { department: options[:current_user_department] }).includes(students: :department, supervisors: :department).references(:students, :supervisors)
    end
  end
end
