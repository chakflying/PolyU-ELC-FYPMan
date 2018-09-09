/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'hello_vue' %> if you have styles in your component)
// to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

import Vue from 'vue'
import App from '../app.vue'
import Assign from '../assign.vue'
import VueResource from 'vue-resource'

Vue.use(VueResource)

// document.addEventListener('DOMContentLoaded', () => {
//   const el = document.body.appendChild(document.createElement('hello'))
//   const app = new Vue({
//     el,
//     render: h => h(App)
//   })

//   console.log(app)
// })

document.addEventListener('turbolinks:load', () => {
  var element = document.getElementById("hello")
  if (element != null) {
    const el = element
    const app = new Vue({
      el,
      render: h => h(App),
    });
  }
});

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
    student_dropdown_list.push(student_netIDs[i]);
  }
  for (i = 0; i < supervisor_netIDs.length; i += 1) {
    supervisor_dropdown_list.push(supervisor_netIDs[i]);
  }
  // console.log("Logggggg");
  // console.log(student_dropdown_list);
  const props = {students: student_dropdown_list, supervisors: supervisor_dropdown_list}

  if (element != null && props != null) {
    const el = element
    const app = new Vue({
      el,
      render: h => h(Assign, { props }),
    });
  }
});


// The above code uses Vue without the compiler, which means you cannot
// use Vue to target elements in your existing html templates. You would
// need to always use single file components.
// To be able to target elements in your existing html/erb templates,
// comment out the above code and uncomment the below
// Add <%= javascript_pack_tag 'hello_vue' %> to your layout
// Then add this markup to your html template:
//
// <div id='hello'>
//   {{message}}
//   <app></app>
// </div>


// import Vue from 'vue/dist/vue.esm'
// import App from '../app.vue'
//
// document.addEventListener('DOMContentLoaded', () => {
//   const app = new Vue({
//     el: '#hello',
//     data: {
//       message: "Can you say hello?"
//     },
//     components: { App }
//   })
// })
//
//
//
// If the using turbolinks, install 'vue-turbolinks':
//
// yarn add 'vue-turbolinks'
//
// Then uncomment the code block below:
//
// import TurbolinksAdapter from 'vue-turbolinks'
// import Vue from 'vue/dist/vue.esm'
// import App from '../app.vue'
//
// Vue.use(TurbolinksAdapter)
//
// document.addEventListener('turbolinks:load', () => {
//   const app = new Vue({
//     el: '#hello',
//     data: {
//       message: "Can you say hello?"
//     },
//     components: { App }
//   })
// })
