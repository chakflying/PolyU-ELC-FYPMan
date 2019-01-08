<template id="timeline-template">
  <ul class="timeline">
    <li v-for="item in m_items" is="timeline-item" :item="item"></li>
  </ul>
</template>

<script>
import TimelineItem from "./timeline-item.vue";
export default {
  components: {
    "timeline-item": TimelineItem
  },

  props: ["items"],

  data: function() {
    return {
      m_items: [],
      m_show_past: false,
    };
  },

  events: {
  },

  methods: {
    toggleShowPast: function() {
      this.m_show_past = !this.m_show_past;
      this.updateItems(this.items);
    },
    updateItems: function(old_items) {
      var now = Date.now();
      this.m_items = this.m_show_past
        ? old_items.filter(item => Date.parse(item.eta) <= now)
        : old_items.filter(item => Date.parse(item.eta) >= now);
    },
    fetchItems: function() {
      var csrfToken = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");
      this.$http
        .get(
          "/todos",
          {},
          { headers: { "X-CSRF-Token": csrfToken } }
        )
        .then(
          response => {
            // get status
            if (response.status != 200) Turbolinks.visit(window.location);
            var items = response.body;
            items.map(obj => {
              obj.icon_class = "fas fa-book";
              obj.icon_status = obj.color;
              obj.eta = obj.eta.replace(/\T(.*)/, "");
              obj.controls = [
                {
                  method: "edit",
                  icon_class: "fas fa-pen"
                },
                {
                  method: "delete",
                  icon_class: "fas fa-trash"
                }
              ];
            });

            this.updateItems(items);

            // get status text
            // response.statusText;
            // get 'Expires' header
            // response.headers.get("Expires");
          },
          response => {
            // error callback
            Turbolinks.visit(window.location);
          }
        );
    },
  },

  created: function() {
    this.updateItems(this.items);
  }
};
</script>