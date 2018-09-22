/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'hello_vue' %> if you have styles in your component)
// to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

import Vue from 'vue'
import VueResource from 'vue-resource'
import App from '../app.vue'
import Assign from '../assign.vue'
import Timeline from '../timeline.vue'

Vue.use(VueResource)

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
    student_dropdown_list.push({id: student_netIDs[i], text: student_netIDs[i] + " " + student_names[i]});
  }
  for (i = 0; i < supervisor_netIDs.length; i += 1) {
    supervisor_dropdown_list.push({id: supervisor_netIDs[i], text: supervisor_netIDs[i] + " " + supervisor_names[i]});
  }
  const props = {students: student_dropdown_list, supervisors: supervisor_dropdown_list}

  if (element != null && props != null) {
    const el = element
    const app = new Vue({
      el,
      render: h => h(Assign, { props }),
    });
  }
});

document.addEventListener('turbolinks:load', () => {
  var element = document.getElementById("todo")
  if (element != null) {
    const el = element
    var parsed_props = JSON.parse(element.getAttribute('data'))
    parsed_props.items2.map((obj) => {
      obj.icon_class = 'fas fa-book';
      obj.icon_status = 'warning';
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
      return obj;
    })
    const props = {
      items: parsed_props.items2,
    }
    
      new Vue({
          el,

          render: h => h(Timeline, { props }),
              
          events: {
              'timeline-delete-item': function(id) {
                  // this.timeline = _.remove(this.timeline, function(item) { 
                  //     return item.id != id 
                  // });
                  var csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
                  this.$http.post('/todos', {id: id}, {method: "DELETE", headers: {'X-CSRF-Token': csrfToken}}).then(response => {
                      // get status
                  response.status;
                  if(response.body == "submitted") {
                      Turbolinks.visit(window.location);
                  }
      
                  // get status text
                  response.statusText;
      
                  // get 'Expires' header
                  response.headers.get('Expires');
      
                  // get body data
                  // console.log(response.body);
      
                  }, response => {
                      // error callback
                  });
              }
          }
      })
  }
});