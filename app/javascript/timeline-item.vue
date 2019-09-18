<template id="timeline-item-template">
  <li class="timeline-item">
    <div :class="'timeline-badge ' + item.icon_status">
      <i :class="item.icon_class"></i>
    </div>
    <div class="timeline-panel card" v-on:click="expanded = !expanded" v-bind:class="{active: expanded}">
      <div class="timeline-heading">
        <h4 class="timeline-title col-lg-9 col-sm-8 col-xs-12">{{ item.title }}</h4>
        <p class="timeline-department">
          {{ ( item.department ? item.department.name : "All Departments" ) }}
        </p>
        <div class="timeline-panel-controls">
          <div class="controls">
            <a v-for="control in item.controls" is="timeline-control" :control="control" :key="control.method"></a>
          </div>
          <div class="timestamp">
            <span class="text-muted">{{ item.eta }}</span>
          </div>
        </div>
      </div>
      <transition name="slide">
        <div class="timeline-description" v-show="expanded == true">{{ item.description }}</div>
      </transition>
    </div>
  </li>
</template>

<script>
import TimelineControl from "./timeline-control.vue";
export default {
  components: {
    "timeline-control": TimelineControl
  },

  props: ["item"],

  data: function() {
    return {
      expanded: false
    };
  },

  methods: {
    delete: function(event) {
      // this.$dispatch('timeline-delete-item', this.item.id)
      var csrfToken = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");
      if (confirm("Do you want to delete this Todo item?")) {
        this.$http
          .delete(document.root_postfix + "/todos/" + this.item.id, {
            body: { id: this.item.id },
            headers: { "X-CSRF-Token": csrfToken }
          })
          .then(
            response => {
              if (response.status != 200) Turbolinks.visit(window.location);
              if (response.body == "submitted") {
                this.$parent.fetchItems();
              } else if (response.body == "failed") {
                Turbolinks.visit(window.location);
              }
              // get status text
              // response.statusText;
              // get 'Expires' header
              // response.headers.get('Expires');
              // console.log(response.body);
            },
            response => {
              // error callback
            }
          );
      }
    },

    edit: function(event) {
      Turbolinks.visit(document.root_postfix + "/todos/" + this.item.id + "/edit");
    }
  },

  events: {
    "timeline-delete": function() {
      this.delete();
    },

    "timeline-edit": function() {
      this.edit();
    }
  }
};
</script>