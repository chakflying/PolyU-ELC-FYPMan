$(document).on("turbolinks:click", function() {
  $(".page-content")
    .addClass("animated fadeOut")
    .off("webkitAnimationEnd oanimationend msAnimationEnd animationend");
});

$(document).on("turbolinks:load", function(event) {
  if (event.originalEvent.data.timing.visitStart) {
    $(".page-content")
      .addClass("animated fadeIn")
      .one("webkitAnimationEnd oanimationend msAnimationEnd animationend", function() {
        $(".page-content").removeClass("animated");
      });
  } else {
    $(".page-content").removeClass("hide");
  }
});
