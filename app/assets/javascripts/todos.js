function toggleClassDelay(element, classname, delay) {
  window.setTimeout(function() {
    element.toggleClass(classname);
  }, delay);
}

$(document).on("click", ".todo-refresh-btn", function() {
  window.todo_vue.$children[0].fetchItems();
  $(this)
    .children()
    .first()
    .toggleClass("fa-spin");
  toggleClassDelay(
    $(this)
      .children()
      .first(),
    "fa-spin",
    2000
  );
});

$(document).on("click", ".todo-toggle-past-btn", function() {
  window.todo_vue.$children[0].toggleShowPast();
  var icon = $(this)
    .children()
    .first();
  var prefix = icon.attr("data-prefix");
  if (prefix === "fas") {
    icon.attr("data-prefix", "far");
  } else {
    icon.attr("data-prefix", "fas");
  }
});
