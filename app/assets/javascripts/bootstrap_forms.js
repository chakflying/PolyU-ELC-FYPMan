// Default bootstrap form validation js
document.addEventListener("turbolinks:load", function() {
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
    autoclose: true
  });

  $("#validation_uni").on("change", function() {
    if ($("#dp_load")) {
      $("#dp_load").remove();
    }
    $("#validation_dp")
      .parent()
      .prepend('<span id="dp_load" style="right: 3em;position: absolute;padding-top: 7px;">&nbsp;<i class="fas fa-sync-alt fa-spin" style="font-size:80%;"></i></span>');
    $.get("/departments_list_by_uni", { id: this.value }, "json")
      .done(function(data) {
        let selectbox = $("#validation_dp");
        selectbox.empty();
        var list = '<option value="" disabled selected hidden>Select Department...</option>';
        for (var j = 0; j < data.length; j++) {
          list += "<option value='" + encodeURI(data[j][1]) + "'>" + data[j][0].replace(/['"<>]+/g, "") + "</option>";
        }
        selectbox.html(list);
        $("#dp_load").remove();
      })
      .fail(function() {
        $("#dp_load").append("&nbsp;<small>check your internet connection.</small>");
      });
    $('#validation_dp').prop('disabled', false); 
  });
});
