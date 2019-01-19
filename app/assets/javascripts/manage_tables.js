document.addEventListener("turbolinks:load", function() {
  if ($(".manage-table").length) {
    document.manage_dataTable = $(".manage-table").DataTable({
      stateSave: true,
      responsive: true,
      columnDefs: [
        { responsivePriority: 2, targets: 2 },
        { responsivePriority: 1, targets: -1 },
        { width: "15px", targets: 0 },
        { width: "25px", targets: -3 },
        { width: "80px", targets: -1 }
      ]
    });
  }
  else if ($(".admin-activity-table").length) {
    document.admin_activity_dataTable = $(".admin-activity-table").DataTable({
      stateSave: true,
      responsive: true,
      columnDefs: [{ responsivePriority: 10001, targets: -1 }],
      order: [[4, "desc"]],
      "processing": true,
      "serverSide": true,
      "ajax": $('.admin-activity-table').data('source'),
      "columns": [
        {"data": "id"},
        {"data": "item_type"},
        {"data": "event"},
        {"data": "whodunnit"},
        {"data": "created_at"},
        {"data": "changeset"}
      ]
    });
  }

  else if ($(".students-table").length) {
    document.students_dataTable = $(".students-table").DataTable({
      stateSave: true,
      deferRender: true,
      responsive: true,
      columnDefs: [
        { responsivePriority: 2, targets: 2 },
        { responsivePriority: 1, targets: -1 },
        { width: "15px", targets: 0 },
        { width: "120px", targets: 1 },
        { width: "120px", targets: 2 },
        { width: "280px", targets: -2 },
        { width: "2.3rem", targets: -1 }
      ],
      language: {
        emptyTable: "No students found in this catogory."
      }
    });
  }

  else if ($(".supervisors-table").length) {
    document.supervisors_dataTable = $(".supervisors-table").DataTable({
      stateSave: true,
      deferRender: true,
      responsive: true,
      columnDefs: [
        { responsivePriority: 2, targets: 2 },
        { responsivePriority: 1, targets: -1 },
        { width: "15px", targets: 0 },
        { width: "150px", targets: 1 },
        { width: "400px", targets: -2 },
        { width: "2.3rem", targets: -1 }
      ],
      language: {
        emptyTable: "No supervisors found in this catogory."
      }
    });
  }

  else if ($(".departments-table").length) {
    document.departments_dataTable = $(".departments-table").DataTable({
      stateSave: true,
      responsive: true,
      columnDefs: [
        { responsivePriority: 2, targets: 1 },
        { responsivePriority: 1, targets: -1 },
        { width: "15px", targets: 0 },
        { width: "80px", targets: -1 }
      ],
      language: {
        emptyTable: "No departments present."
      }
    });
  }
});

document.addEventListener("turbolinks:before-cache", function() {
  if ($.fn.DataTable.isDataTable(".manage-table")) {
    $(".manage-table").dataTable().fnDestroy();
  }
  else if ($.fn.DataTable.isDataTable(".students-table")) {
    $(".students-table").dataTable().fnDestroy();
  }
  else if ($.fn.DataTable.isDataTable(".supervisors-table")) {
    $(".supervisors-table").dataTable().fnDestroy();
  }
  else if ($.fn.DataTable.isDataTable(".admin-activity-table")) {
    $(".admin-activity-table").dataTable().fnDestroy();
  }
  else if ($.fn.DataTable.isDataTable(".departments-table")) {
    $(".departments-table").dataTable().fnDestroy();
  }
});

$(document).on("click", "#db_f_all", function() {
  document.admin_activity_dataTable.columns(1).search("").draw();
  $('.da-nav').removeClass('active');
  $("#db_f_all").addClass('active');
});

$(document).on("click", "#db_f_students", function() {
  document.admin_activity_dataTable.columns(1).search("Student").draw();
  $('.da-nav').removeClass('active');
  $("#db_f_students").addClass('active');
});

$(document).on("click", "#db_f_supervisors", function() {
  document.admin_activity_dataTable.columns(1).search("Supervisor").draw();
  $('.da-nav').removeClass('active');
  $("#db_f_supervisors").addClass('active');
});

$(document).on("click", "#db_f_users", function() {
  document.admin_activity_dataTable.columns(1).search("User").draw();
  $('.da-nav').removeClass('active');
  $("#db_f_users").addClass('active');
});

$(document).on("click", "#db_f_todos", function() {
  document.admin_activity_dataTable.columns(1).search("Todo").draw();
  $('.da-nav').removeClass('active');
  $("#db_f_todos").addClass('active');
});

$(document).on("click", "#db_f_departments", function() {
  document.admin_activity_dataTable.columns(1).search("Department").draw();
  $('.da-nav').removeClass('active');
  $("#db_f_departments").addClass('active');
});
