import Vue from "vue";
import Assign from "../assign.vue";
import VueResource from "vue-resource";
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
