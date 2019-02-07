import Vue from "vue";
import Timeline from "../timeline.vue";
import VueResource from "vue-resource";
import TurbolinksAdapter from "vue-turbolinks";

Vue.use(TurbolinksAdapter);
Vue.use(VueResource);

document.addEventListener("turbolinks:load", () => {
  const el = document.getElementById("todo");
  if (el == null) return;
  const parsed_props = JSON.parse(el.getAttribute("data"));
  parsed_props.items2.map(obj => {
    obj.icon_class = "fas fa-book";
    obj.icon_status = obj.color;
    obj.eta = obj.eta.replace(/\T(.*)/, "");
    obj.controls = [
      {
        method: "edit",
        icon_class: "fas fa-pen"
      },
      {
        method: "delete",
        icon_class: "fas fa-trash"
      }
    ];
  });

  const props = {
    items: parsed_props.items2
  };

  if (props != null) {
    window.todo_vue = new Vue({
      el,
      render: h => h(Timeline, { props }),
      events: {}
    });
  }
});
