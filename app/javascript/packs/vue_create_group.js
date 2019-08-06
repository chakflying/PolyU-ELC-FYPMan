import Vue from "vue";
import CreateGroup from "../create-group.vue";
import VueResource from "vue-resource";
import TurbolinksAdapter from "vue-turbolinks";
import vSelect from "vue-select";

Vue.component("v-select", vSelect);
Vue.use(TurbolinksAdapter);
Vue.use(VueResource);

function loadVueCreateGroup() {
  const el = document.getElementById("createGroup-form-vue");
  if (el == null) return;
  const parsed_props = JSON.parse(el.getAttribute("data"));
  let student_dropdown_list = parsed_props.students.map(function(a) {
    if (a.name == null || a.name == "") {
      return { value: a.id, label: a.netID };
    } else {
      return { value: a.id, label: a.netID + "  -  " + a.name };
    }
  });
  const props = {
    students: student_dropdown_list,
  };

  if (props != null) {
    window.assign_vue = new Vue({
      el,
      render: h => h(CreateGroup, { props })
    });
  }
}

document.addEventListener("turbolinks:load", () => {
  loadVueCreateGroup();
});

loadVueCreateGroup();
