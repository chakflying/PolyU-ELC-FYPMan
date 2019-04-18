String.prototype.formatUnicorn =
  String.prototype.formatUnicorn ||
  function() {
    "use strict";
    var str = this.toString();
    if (arguments.length) {
      var t = typeof arguments[0];
      var key;
      var args = "string" === t || "number" === t ? Array.prototype.slice.call(arguments) : arguments[0];

      for (key in args) {
        str = str.replace(new RegExp("\\{" + key + "\\}", "gi"), args[key]);
      }
    }

    return str;
  };

document.addEventListener("turbolinks:load", function() {
  if ($(".admin-users-table").length) {
    document.manage_dataTable = $(".admin-users-table").DataTable({
      stateSave: true,
      stateDuration: 60 * 60 * 24,
      responsive: true,
      columnDefs: [{ responsivePriority: 2, targets: 2 }, { responsivePriority: 1, targets: -1 }, { width: "1em", targets: 0 }, { width: "1.3em", targets: -3 }, { width: "6.5em", targets: -1 }]
    });
  } else if ($(".admin-activity-table").length) {
    document.admin_activity_dataTable = $(".admin-activity-table").DataTable({
      stateSave: true,
      stateDuration: 60 * 60 * 24,
      responsive: true,
      columnDefs: [{ responsivePriority: 10001, targets: -1 }],
      order: [[4, "desc"]],
      processing: true,
      serverSide: true,
      ajax: $(".admin-activity-table").data("source"),
      columns: [{ data: "id" }, { data: "item_type" }, { data: "event" }, { data: "whodunnit" }, { data: "created_at" }, { data: "changeset" }]
    });
  } else if ($(".students-table").length) {
    document.students_dataTable = $(".students-table").DataTable({
      processing: true,
      serverSide: true,
      ajax: $(".students-table").data("source"),
      order: [[0, "asc"]],
      stateSave: true,
      stateDuration: 60 * 60 * 24,
      responsive: true,
      columns: [{ data: "id" }, { data: "name" }, { data: "netID" }, { data: "department" }, { data: "fyp_year" }, { data: "supervisors" }, { data: "dt_action" }],
      columnDefs: [
        { responsivePriority: 2, targets: 2 },
        { responsivePriority: 1, targets: -1 },
        { width: "1em", targets: 0 },
        { width: "10em", targets: 1 },
        { width: "10em", targets: 2 },
        { width: "20em", targets: -2 },
        { width: "2em", targets: -1 }
      ],
      language: {
        emptyTable: "No students found in this catogory."
      }
    });
    if ($("#data").data("admin") === false) {
      document.students_dataTable.column(3).visible(false);
      document.students_dataTable.columns.adjust().draw();
    } else {
      document.students_dataTable.column(3).visible(true);
      document.students_dataTable.columns.adjust().draw();
    }
  } else if ($(".supervisors-table").length) {
    document.supervisors_dataTable = $(".supervisors-table").DataTable({
      processing: true,
      serverSide: true,
      ajax: $(".supervisors-table").data("source"),
      order: [[0, "asc"]],
      stateSave: true,
      stateDuration: 60 * 60 * 24,
      responsive: true,
      columns: [{ data: "id" }, { data: "name" }, { data: "netID" }, { data: "department" }, { data: "students" }, { data: "dt_action" }],
      columnDefs: [
        { responsivePriority: 2, targets: 2 },
        { responsivePriority: 1, targets: -1 },
        { width: "1em", targets: 0 },
        { width: "10em", targets: 1 },
        { width: "10em", targets: 2 },
        { width: "2em", targets: -1 }
      ],
      language: {
        emptyTable: "No supervisors found in this catogory."
      }
    });
    if ($("#data").data("admin") === false) {
      document.supervisors_dataTable.column(3).visible(false);
      document.supervisors_dataTable.columns.adjust().draw();
    } else {
      document.supervisors_dataTable.column(3).visible(true);
      document.supervisors_dataTable.columns.adjust().draw();
    }
  } else if ($(".departments-table").length) {
    document.departments_dataTable = $(".departments-table").DataTable({
      stateSave: true,
      stateDuration: 60 * 60 * 24,
      responsive: true,
      columnDefs: [{ responsivePriority: 2, targets: 1 }, { responsivePriority: 1, targets: -1 }, { width: "1em", targets: 0 }, { width: "6.5em", targets: -1 }],
      language: {
        emptyTable: "No departments present."
      }
    });
  }
});

document.addEventListener("turbolinks:before-cache", function() {
  if ($.fn.DataTable.isDataTable(".admin-users-table")) {
    $(".admin-users-table")
      .dataTable()
      .fnDestroy();
  } else if ($.fn.DataTable.isDataTable(".students-table")) {
    $(".students-table")
      .dataTable()
      .fnDestroy();
  } else if ($.fn.DataTable.isDataTable(".supervisors-table")) {
    $(".supervisors-table")
      .dataTable()
      .fnDestroy();
  } else if ($.fn.DataTable.isDataTable(".admin-activity-table")) {
    $(".admin-activity-table")
      .dataTable()
      .fnDestroy();
  } else if ($.fn.DataTable.isDataTable(".departments-table")) {
    $(".departments-table")
      .dataTable()
      .fnDestroy();
  }
});

$(document).on("click", "#db_f_all", function() {
  document.admin_activity_dataTable
    .columns(1)
    .search("")
    .draw();
  $(".da-nav").removeClass("active");
  $("#db_f_all").addClass("active");
});

$(document).on("click", "#db_f_students", function() {
  document.admin_activity_dataTable
    .columns(1)
    .search("Student")
    .draw();
  $(".da-nav").removeClass("active");
  $("#db_f_students").addClass("active");
});

$(document).on("click", "#db_f_supervisors", function() {
  document.admin_activity_dataTable
    .columns(1)
    .search("Supervisor")
    .draw();
  $(".da-nav").removeClass("active");
  $("#db_f_supervisors").addClass("active");
});

$(document).on("click", "#db_f_supervisions", function() {
  document.admin_activity_dataTable
    .columns(1)
    .search("Supervision")
    .draw();
  $(".da-nav").removeClass("active");
  $("#db_f_supervisions").addClass("active");
});

$(document).on("click", "#db_f_users", function() {
  document.admin_activity_dataTable
    .columns(1)
    .search("User")
    .draw();
  $(".da-nav").removeClass("active");
  $("#db_f_users").addClass("active");
});

$(document).on("click", "#db_f_todos", function() {
  document.admin_activity_dataTable
    .columns(1)
    .search("Todo")
    .draw();
  $(".da-nav").removeClass("active");
  $("#db_f_todos").addClass("active");
});

$(document).on("click", "#db_f_departments", function() {
  document.admin_activity_dataTable
    .columns(1)
    .search("Department")
    .draw();
  $(".da-nav").removeClass("active");
  $("#db_f_departments").addClass("active");
});

$(document).on("click", ".dt-btn-rm", function() {
  var csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute("content");
  $(this).prop("disabled", true);
  $(this).html('<i class="fas fa-sync-alt fa-spin"></i>');

  $.ajax({
    url: "/unassign",
    type: "POST",
    context: this,
    headers: { "X-CSRF-Token": csrfToken },
    data: {
      supervisor_netID: this.dataset.sup_netid,
      student_netID: this.dataset.stu_netid
    },
    dataType: "text",
    success: function(data) {
      if (data == "submitted") {
        $(this)
          .parent()
          .parent()
          .fadeOut(function() {
            var div = jQuery(
              '<div class="row dt-rel-row"><div class="col-9 dt-rel-name"><i class="fas fa-user-slash"></i>&nbsp; Unassigned successfully.</div><div class="col-3"><button class="btn btn-sm btn-light dt-btn-rmundo" data-stu_netID="{0}" data-sup_netID="{1}" aria-label="Undo">Undo</button></div></div>'.formatUnicorn(
                this.children[2] ? this.children[2].children[0].dataset.stu_netid : this.children[1].children[0].dataset.stu_netid,
                this.children[2] ? this.children[2].children[0].dataset.sup_netid : this.children[1].children[0].dataset.sup_netid
              )
            );
            $(this).replaceWith(div);
            $(this).fadeIn();
          });
      } else {
        $(this)
          .parent()
          .parent()
          .fadeOut(function() {
            var div = jQuery('<div class="row dt-rel-row"><div class="col-sm-12 dt-rel-name" style="color:#721c24"><i class="fas fa-times"></i>&nbsp; Unassign error, please refresh.</div></div>');
            $(this).replaceWith(div);
            $(this).fadeIn();
          });
      }
    },
    error: function(data) {
      $(this)
        .parent()
        .parent()
        .fadeOut(function() {
          var div = jQuery('<div class="row dt-rel-row"><div class="col-sm-12 dt-rel-name" style="color:#721c24"><i class="fas fa-times"></i>&nbsp; Network error, please try again.</div></div>');
          $(this).replaceWith(div);
          $(this).fadeIn();
        });
    }
  });
});

$(document).on("click", ".dt-btn-rmundo", function() {
  var csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute("content");
  $(this).prop("disabled", true);
  $(this).html('<i class="fas fa-sync-alt fa-spin"></i>');

  $.ajax({
    url: "/ajaxassign",
    type: "POST",
    context: this,
    headers: { "X-CSRF-Token": csrfToken },
    data: {
      supervisor_netID: this.dataset.sup_netid,
      student_netID: this.dataset.stu_netid
    },
    dataType: "text",
    success: function(data) {
      if (data == "submitted") {
        if (document.students_dataTable != null) {
          document.students_dataTable.ajax.reload();
        }
        if (document.supervisors_dataTable != null) {
          document.supervisors_dataTable.ajax.reload();
        }
      } else {
        $(this)
          .parent()
          .parent()
          .fadeOut(function() {
            var div = jQuery('<div class="row dt-rel-row"><div class="col-sm-12 dt-rel-name" style="color:#721c24"><i class="fas fa-times"></i>&nbsp; Unassign error, please refresh.</div></div>');
            $(this).replaceWith(div);
            $(this).fadeIn();
          });
      }
    },
    error: function(data) {
      $(this)
        .parent()
        .parent()
        .fadeOut(function() {
          var div = jQuery('<div class="row dt-rel-row"><div class="col-sm-12 dt-rel-name" style="color:#721c24"><i class="fas fa-times"></i>&nbsp; Network error, please try again.</div></div>');
          $(this).replaceWith(div);
          $(this).fadeIn();
        });
    }
  });
});
