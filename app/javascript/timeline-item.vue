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
                            <small class="text-muted">{{ item.created }}</small>
                        </div>
                    </div>
                </div>
                <div class="timeline-body" v-html="item.body"></div>
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
        delete: function() {
            this.$dispatch('timeline-delete-item', this.item.id)
        },
        
        edit: function() {
            
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