document.addEventListener("turbolinks:load", function() {
  $(".datepicker").pickadate({
    formatSubmit: "yyyy/mm/dd",
    hiddenName: true,
    clear: false,
  });
});
