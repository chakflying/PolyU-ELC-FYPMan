import Vue from 'vue'
import VueResource from 'vue-resource'
import Timeline from '../timeline.vue'

Vue.use(VueResource)

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

