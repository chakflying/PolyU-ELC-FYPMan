<template id="timeline-template">
    <ul class="timeline">
        <li 
            v-for="item in items" 
            is="timeline-item" 
            :item="item">
        </li>
    </ul>
</template>

<script>
import TimelineItem from './timeline-item.vue'
export default {
    components: {
        'timeline-item': TimelineItem
    },

    props: ['items'],
        
    events: {
        'delete-item': function() {
            return true; // forward to parent
        }
    }
}
</script>