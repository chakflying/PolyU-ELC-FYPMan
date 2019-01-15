<template id="timeline-control-template">
  <a v-on:click.stop="handleClick">
    <i :class="control.icon_class"></i>
  </a>
</template>

<script>
export default {
  props: ["control"],

  methods: {
    handleClick: function(event) {
      if (this.control.method == "delete") {
        this.timeline_delete_item(event);
      } else if (this.control.method == "edit") {
        this.timeline_edit_item(event);
      } else {
        console.log("Unknown method " + this.control.method);
      }
    },
    timeline_delete_item: function(event) {
      this.$parent.delete(event);
    },
    timeline_edit_item: function(event) {
      this.$parent.edit(event);
    }
  }
};
</script>