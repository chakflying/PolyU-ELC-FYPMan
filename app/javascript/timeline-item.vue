<template id="timeline-item-template">
    <li class="timeline-item">
        <div :class="'timeline-badge ' + item.icon_status"><i :class="item.icon_class"></i></div>
            <div class="timeline-panel">
                <div class="timeline-heading">
                    <h4 class="timeline-title">{{ item.title }}</h4>
                    <div class="timeline-panel-controls">
                        <div class="controls">
                            <a 
                                v-for="control in item.controls" 
                                is="timeline-control" 
                                :control="control">
                            </a>
                        </div>
                        <div class="timestamp">
                            <span class="text-muted">{{ item.eta }}</span>
                        </div>
                    </div>
                </div>
                <div class="timeline-description" v-html="item.description"></div>
            </div>
        </div>
    </li>
</template>

<script>
import TimelineControl from './timeline-control.vue'
export default {
    components: {
        'timeline-control': TimelineControl
    },

    props: ['item'],
        
    methods: {
        delete: function(event) {
            // this.$dispatch('timeline-delete-item', this.item.id)
            var csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
            console.log(this);
            this.$http.delete('/todos', {body: {id: this.item.id}, headers: {'X-CSRF-Token': csrfToken}}).then(response => {
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
        },
        
        edit: function(event) {
            Turbolinks.visit('/todos/' + this.item.id);
        }
    },
    
    events: {
        'timeline-delete': function() {
            this.delete();
        },
        
        'timeline-edit': function() {
            this.edit();
        }
    }
}
</script>