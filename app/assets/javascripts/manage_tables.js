var dataTable = null

document.addEventListener("turbolinks:load", function() {
    if ( ! $.fn.DataTable.isDataTable( '.manage-table' ) ) {
        $('.manage-table').dataTable({
            stateSave: true,
            responsive: true,
            columnDefs: [
                { responsivePriority: 2, targets: 2 },
                { responsivePriority: 1, targets: -1 },
                {'width': '5%', 'targets': 0},
                {'width': '17%', 'targets': 1},
                {'width': '10%', 'targets': 2},
                {'width': '35%', 'targets': -2},
                {'width': '57px', 'targets': -1},
            ]
        });
    }
});

// $(function(){
//     $('.manage-table').DataTable({stateSave: true});
// });