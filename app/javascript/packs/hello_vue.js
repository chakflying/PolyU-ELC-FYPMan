/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'hello_vue' %> if you have styles in your component)
// to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

import Vue from 'vue'
import VueResource from 'vue-resource'
import Assign from '../assign.vue'
import Timeline from '../timeline.vue'
import TurbolinksAdapter from 'vue-turbolinks';

Vue.use(TurbolinksAdapter)
Vue.use(VueResource)


document.addEventListener('turbolinks:load', () => {
    var element = document.getElementById("assign-form-vue")
    if (element == null) {
        return;
    }
    const parsed_props = JSON.parse(element.getAttribute('data'))
    var student_netIDs = parsed_props.students.map(a => a.netID);
    var student_names = parsed_props.students.map(a => a.name);
    var supervisor_netIDs = parsed_props.supervisors.map(a => a.netID);
    var supervisor_names = parsed_props.supervisors.map(a => a.name);
    var student_dropdown_list = []
    var supervisor_dropdown_list = []
    var i;
    for (i = 0; i < student_netIDs.length; i += 1) {
        student_dropdown_list.push({ id: student_netIDs[i], text: student_netIDs[i] + " " + student_names[i] });
    }
    for (i = 0; i < supervisor_netIDs.length; i += 1) {
        supervisor_dropdown_list.push({ id: supervisor_netIDs[i], text: supervisor_netIDs[i] + " " + supervisor_names[i] });
    }
    const props = { students: student_dropdown_list, supervisors: supervisor_dropdown_list }

    if (element != null && props != null) {
        const el = element
        new Vue({
            el,
            render: h => h(Assign, { props }),
        });
    }
});

document.addEventListener('turbolinks:load', () => {
    var element = document.getElementById("todo");
    if (element != null) {
        const el = element;
        var parsed_props = JSON.parse(element.getAttribute('data'));
        parsed_props.items2.map((obj) => {
            obj.icon_class = 'fas fa-book';
            obj.icon_status = obj.color;
            obj.eta = obj.eta.replace(/\T(.*)/, "");
            obj.controls = [
                {
                    method: 'edit',
                    icon_class: 'fas fa-pen'
                },
                {
                    method: 'delete',
                    icon_class: 'fas fa-trash'
                }
            ];
        });

        var props = {
            items: parsed_props.items2,
        };

        window.todo_vue = new Vue({
            el,

            render: h => h(Timeline, { props }),

            events: {
            }
        })
    }
});