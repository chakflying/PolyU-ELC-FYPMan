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
                { 'width': '35%', 'targets': -2 },
                { 'width': '70px', 'targets': -1 },
            ]
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
                { 'width': '35%', 'targets': -2 },
                { 'width': '70px', 'targets': -1 },
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
                { 'width': '5%', 'targets': 0 },
                { 'width': '17%', 'targets': 1 },
                { 'width': '10%', 'targets': 2 },
                { 'width': '35%', 'targets': -2 },
                { 'width': '70px', 'targets': -1 },
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
