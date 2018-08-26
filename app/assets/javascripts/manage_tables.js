var dataTable = null

document.addEventListener("turbolinks:load", function() {
    if ( ! $.fn.DataTable.isDataTable( '.manage-table' ) ) {
        $('.manage-table').dataTable({stateSave: true});
    }
});

// $(function(){
//     $('.manage-table').DataTable({stateSave: true});
// });