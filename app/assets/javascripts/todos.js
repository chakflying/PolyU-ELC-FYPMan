function toggleClassDelay(element,classname,delay) {
    window.setTimeout(function() {
        element.toggleClass(classname);
    },delay);
}

document.addEventListener("turbolinks:load", function () {
    $(".rotate").parent().click(function () {
        $(this).children().toggleClass("fa-spin");
        toggleClassDelay($(this).children(), "fa-spin", 2000);
    });
    $(".past").parent().click(function () {
        $(this).children().first().toggleClass("fas").toggleClass("far");
    });
});
