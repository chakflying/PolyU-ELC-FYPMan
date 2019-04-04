document.addEventListener("turbolinks:load", function() {
  $(".datepicker").datepicker({
    format: "yyyy/mm/dd",
    autoclose: true,
  });
});
