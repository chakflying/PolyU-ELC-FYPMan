<template id="timeline-template">
  <ul class="timeline">
    <li v-for="item in m_display_items" is="timeline-item" :item="item" :key="item.id"></li>
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
      m_display_items: [],
      m_show_past: false
    };
  },

  events: {},

  methods: {
    toggleShowPast: function() {
      this.m_show_past = !this.m_show_past;
      this.updateItems(this.m_items);
    },
    updateItems: function(in_items) {
      this.m_items = in_items;
      var now = Date.now();
      this.m_display_items = this.m_show_past
        ? in_items.filter(item => Date.parse(item.eta) <= now).sort(function (a, b) {return new Date(b.eta) - new Date(a.eta);})
        : in_items.filter(item => Date.parse(item.eta) >= now);
    },
    fetchItems: function() {
      var csrfToken = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");
      let response_status = this.$http
        .get("/todos", {}, { headers: { "X-CSRF-Token": csrfToken } })
        .then(
          response => {
            // get status
            if (response.status != 200) return response.status;
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
            return response.status;
          },
          response => {
            // error callback
            return -1;
          }
        );
        return response_status;
    }
  },

  created: function() {
    this.updateItems(this.items);
  }
};
</script>

<style lang="scss">
.timeline {
  list-style: none;
  padding: 20px 0 20px;
  position: relative;

  &:before {
    background-color: #eee;
    bottom: 0;
    content: " ";
    left: 50px;
    margin-left: -8.5px;
    position: absolute;
    top: 0;
    width: 3px;
    z-index: -10;
  }

  > li {
    margin-bottom: 20px;
    position: relative;

    &:before,
    &:after {
      content: " ";
      display: table;
    }

    &:after {
      clear: both;
    }

    > .timeline-panel {
      border-radius: 6px;
      border: 1px solid #d4d4d4;
      box-shadow: -1px 1px 2px rgba(100, 100, 100, 0.4);
      margin-left: 80px;
      padding: 20px;
      position: relative;

      .timeline-heading {
        .timeline-panel-controls {
          position: absolute;
          right: 8px;
          top: 5px;

          .timestamp {
            display: inline-block;
          }

          .controls {
            display: inline-block;
            padding-right: 5px;
            border-right: 1px solid #aaa;

            a {
              color: #999;
              font-size: 15px;
              padding: 0 5px;

              &:hover {
                color: #333;
                text-decoration: none;
                cursor: pointer;
              }
            }
          }

          .controls + .timestamp {
            padding-left: 5px;
            padding-right: 10px;
            padding-top: 12px;
            font-size: 150%;
          }
        }
      }
    }

    .timeline-panel.active {
      box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25) !important;
    }

    .timeline-badge {
      background-color: #999;
      border-radius: 50%;
      color: #fff;
      font-size: 1em;
      height: 50px;
      left: 50px;
      line-height: 49px;
      margin-left: -33px;
      position: absolute;
      text-align: center;
      top: 16px;
      width: 50px;
      z-index: 1;
      box-shadow: -3px 3px 5px rgba(50, 50, 50, 0.37);
    }

    .timeline-badge + .timeline-panel {
      &:before {
        border-bottom: 15px solid transparent;
        border-left: 0 solid #ccc;
        border-right: 15px solid #ccc;
        border-top: 15px solid transparent;
        content: " ";
        display: inline-block;
        position: absolute;
        left: -15px;
        right: auto;
        top: 26px;
      }

      &:after {
        border-bottom: 14px solid transparent;
        border-left: 0 solid #fff;
        border-right: 14px solid #fff;
        border-top: 14px solid transparent;
        content: " ";
        display: inline-block;
        position: absolute;
        left: -14px;
        right: auto;
        top: 27px;
      }
    }
  }
}

.timeline-badge {
  &.primary {
    background-color: #2e6da4 !important;
  }

  &.success {
    background-color: #3f903f !important;
  }

  &.warning {
    background-color: #f0ad4e !important;
  }

  &.danger {
    background-color: #d9534f !important;
  }

  &.info {
    background-color: #5bc0de !important;
  }
}

.timeline-title {
  margin-top: 0;
  margin-bottom: 0.15em;
  color: inherit;
}
@media only screen and (max-width: 767px) {
  .timeline-title {
    font-size: 1.3rem !important;
    margin-top: 1.8em !important;
    padding-left: 0 !important;
  }
}

.timeline-department {
  color: grey;
  margin: 0 0 0.5em 1em;
  font-size: 80%;
}
@media only screen and (max-width: 767px) {
  .timeline-department {
    margin: 0 0 0.5em 0.5em;
  }
}

.timeline-description {
  > p,
  > ul {
    margin-bottom: 0;
  }

  > p + p {
    margin-top: 5px;
  }
  color: darkgrey;
  white-space: pre-wrap;
  margin-left: 0.8em;
}
@media only screen and (max-width: 767px) {
  .timeline-description {
    font-size: 85% !important;
    margin-left: 0;
  }
}

.copy {
  position: absolute;
  top: 5px;
  right: 5px;
  color: #aaa;
  font-size: 11px;
  > * {
    color: #444;
  }
}

.form-timeline-badge {
  color: white;
  padding: 2px 10px 2px 8px;
  border-radius: 1em;
  margin-right: 7px;
}

.slide-fade-enter-active {
  transition: all 0.3s ease;
}
.slide-fade-leave-active {
  transition: all 0.3s cubic-bezier(1, 0.5, 0.8, 1);
}
.slide-fade-enter,
.slide-fade-leave-to {
  transform: translateX(20px);
  opacity: 0;
}
</style>
