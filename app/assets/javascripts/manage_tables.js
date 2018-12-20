var user_dataTable = null

document.addEventListener("turbolinks:load", function () {
    if (!$.fn.DataTable.isDataTable('.manage-table')) {
        user_dataTable = $('.manage-table').dataTable({
            stateSave: true,
            responsive: true,
            columnDefs: [
                { responsivePriority: 2, targets: 2 },
                { responsivePriority: 1, targets: -1 },
                { 'width': '5%', 'targets': 0 },
                { 'width': '17%', 'targets': 1 },
                { 'width': '10%', 'targets': 2 },
                { 'width': '150px', 'targets': -2 },
                { 'width': '72px', 'targets': -1 },
            ]
        });
    }
    if (!$.fn.DataTable.isDataTable('.admin-activity-table')) {
        user_dataTable = $('.admin-activity-table').dataTable({
            stateSave: true,
            responsive: true,
            columnDefs: [
                { responsivePriority: 10001, targets: -1 },
            ],
            order: [[ 4, "desc" ]]
        });
    }

    if (!$.fn.DataTable.isDataTable('.students-table')) {
        students_dataTable = $('.students-table').dataTable({
            stateSave: true,
            responsive: true,
            columnDefs: [
                { responsivePriority: 2, targets: 2 },
                { responsivePriority: 1, targets: -1 },
                { 'width': '5%', 'targets': 0 },
                { 'width': '17%', 'targets': 1 },
                { 'width': '10%', 'targets': 2 },
                { 'width': '200px', 'targets': -2 },
                { 'width': '4.7rem', 'targets': -1 },
            ],
            language: {
                "emptyTable": "No students found in this catogory."
            }
        });
    }

    if (!$.fn.DataTable.isDataTable('.supervisors-table')) {
        supervisors_dataTable = $('.supervisors-table').dataTable({
            stateSave: true,
            responsive: true,
            columnDefs: [
                { responsivePriority: 2, targets: 2 },
                { responsivePriority: 1, targets: -1 },
                { 'width': '15px', 'targets': 0 },
                { 'width': '250px', 'targets': 1 },
                { 'width': '400px', 'targets': -2 },
                { 'width': '4.7rem', 'targets': -1 },
            ],
            language: {
                "emptyTable": "No supervisors found in this catogory."
            }
        });
    }
});

document.addEventListener("turbolinks:before-cache", function () {
    if ($.fn.DataTable.isDataTable('.manage-table')) {
        user_dataTable.dataTable().fnDestroy();
    }
    if ($.fn.DataTable.isDataTable('.students-table')) {
        students_dataTable.dataTable().fnDestroy();
    }
    if ($.fn.DataTable.isDataTable('.supervisors-table')) {
        supervisors_dataTable.dataTable().fnDestroy();
    }
});
