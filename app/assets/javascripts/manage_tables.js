document.addEventListener("turbolinks:load", function() {
  if (!$.fn.DataTable.isDataTable(".manage-table")) {
    document.manage_dataTable = $(".manage-table").dataTable({
      stateSave: true,
      responsive: true,
      columnDefs: [
        { responsivePriority: 2, targets: 2 },
        { responsivePriority: 1, targets: -1 },
        { width: "5%", targets: 0 },
        { width: "17%", targets: 1 },
        { width: "10%", targets: 2 },
        { width: "150px", targets: -2 },
        { width: "72px", targets: -1 }
      ]
    });
  }
  if (!$.fn.DataTable.isDataTable(".admin-activity-table")) {
    document.admin_activity_dataTable = $(".admin-activity-table").dataTable({
      stateSave: true,
      responsive: true,
      columnDefs: [{ responsivePriority: 10001, targets: -1 }],
      order: [[4, "desc"]]
    });
  }

  if (!$.fn.DataTable.isDataTable(".students-table")) {
    document.students_dataTable = $(".students-table").dataTable({
      stateSave: true,
      responsive: true,
      columnDefs: [
        { responsivePriority: 2, targets: 2 },
        { responsivePriority: 1, targets: -1 },
        { width: "5%", targets: 0 },
        { width: "150px", targets: 1 },
        { width: "10%", targets: 2 },
        { width: "230px", targets: -2 },
        { width: "4.7rem", targets: -1 }
      ],
      language: {
        emptyTable: "No students found in this catogory."
      }
    });
  }

  if (!$.fn.DataTable.isDataTable(".supervisors-table")) {
    document.supervisors_dataTable = $(".supervisors-table").dataTable({
      stateSave: true,
      responsive: true,
      columnDefs: [
        { responsivePriority: 2, targets: 2 },
        { responsivePriority: 1, targets: -1 },
        { width: "15px", targets: 0 },
        { width: "250px", targets: 1 },
        { width: "400px", targets: -2 },
        { width: "4.7rem", targets: -1 }
      ],
      language: {
        emptyTable: "No supervisors found in this catogory."
      }
    });
  }

  if (!$.fn.DataTable.isDataTable(".departments-table")) {
    document.departments_dataTable = $(".departments-table").dataTable({
      stateSave: true,
      responsive: true,
      columnDefs: [
        { responsivePriority: 2, targets: 1 },
        { responsivePriority: 1, targets: -1 },
        { width: "15px", targets: 0 },
        { width: "4.7rem", targets: -1 }
      ],
      language: {
        emptyTable: "No departments present."
      }
    });
  }
});

document.addEventListener("turbolinks:before-cache", function() {
  if ($.fn.DataTable.isDataTable(".manage-table")) {
    document.manage_dataTable.dataTable().fnDestroy();
  }
  if ($.fn.DataTable.isDataTable(".students-table")) {
    document.students_dataTable.dataTable().fnDestroy();
  }
  if ($.fn.DataTable.isDataTable(".supervisors-table")) {
    document.supervisors_dataTable.dataTable().fnDestroy();
  }
  if ($.fn.DataTable.isDataTable(".admin-activity-table")) {
    document.admin_activity_dataTable.dataTable().fnDestroy();
  }
  if ($.fn.DataTable.isDataTable(".departments-table")) {
    document.departments_dataTable.dataTable().fnDestroy();
  }
});
