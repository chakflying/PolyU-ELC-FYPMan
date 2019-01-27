/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'hello_vue' %> if you have styles in your component)
// to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

import Vue from "vue";
import VueResource from "vue-resource";
import Assign from "../assign.vue";
import Timeline from "../timeline.vue";
import TurbolinksAdapter from "vue-turbolinks";
import vSelect from "vue-select";

Vue.component("v-select", vSelect);
Vue.use(TurbolinksAdapter);
Vue.use(VueResource);

document.addEventListener("turbolinks:load", () => {
  const el = document.getElementById("assign-form-vue");
  if (el == null) return;
  const parsed_props = JSON.parse(el.getAttribute("data"));
  let student_dropdown_list = parsed_props.students.map(function(a) {
    return { value: a.netID, label: a.netID + "  -  " + a.name };
  });
  let supervisor_dropdown_list = parsed_props.supervisors.map(function(a) {
    return { value: a.netID, label: a.netID + "  -  " + a.name };
  });
  const props = {
    students: student_dropdown_list,
    supervisors: supervisor_dropdown_list
  };

  if (props != null) {
    window.assign_vue = new Vue({
      el,
      render: h => h(Assign, { props })
    });
  }
});

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
