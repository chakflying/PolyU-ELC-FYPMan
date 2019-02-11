function toggleClassDelay(element, classname, delay) {
  window.setTimeout(function() {
    element.toggleClass(classname);
  }, delay);
}

$(document).on("click", ".todo-refresh-btn", async function () {
  $(this).tooltip("hide");
  $(this)
    .children()
    .first()
    .toggleClass("fa-spin");
  let status = await window.todo_vue.$children[0].fetchItems().promise;
  $(this)
    .children()
    .first()
    .toggleClass("fa-spin");
  if (status !== 200) {
    $(this).tooltip("show");
  }
});

$(document).on("click", ".todo-toggle-past-btn", function() {
  window.todo_vue.$children[0].toggleShowPast();
  var icon = $(this)
    .children()
    .first();
  icon.toggleClass("far fas");
});
