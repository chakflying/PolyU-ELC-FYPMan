// Default bootstrap form validation js
document.addEventListener("turbolinks:load", function () {
  var forms = document.getElementsByClassName("needs-validation");
  Array.prototype.filter.call(forms, function(form) {
    form.addEventListener(
      "submit",
      function(event) {
        if (form.checkValidity() === false) {
          event.preventDefault();
          event.stopPropagation();
        }
        form.classList.add("was-validated");
      },
      false
    );
  });

  $(".datepicker").datepicker({
    format: "dd MM, yyyy",
    autoclose: true,
  });
});
