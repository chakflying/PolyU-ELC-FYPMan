<template>
  <select class="form-control select2-input" required>
    <slot></slot>
  </select>
</template>

<script>
export default {
  props: ["options", "value"],
  mounted: function() {
    var vm = this;
    $(this.$el)
      // init select2
      .select2({
        data: this.options,
        placeholder: "Select...",
        width: "100%",
        theme: "bootstrap"
      })
      .val(this.value)
      .trigger("change")
      // emit event on change.
      .on("change", function() {
        vm.$emit("input", this.value);
      });
    $(document).on("turbolinks:before-cache", function() {
      $(".select2-hidden-accessible").select2("destroy");
    });

    $(document).on("turbolinks:load", function() {
      $(".select2-input").select2({
        data: this.options,
        placeholder: "Select...",
        width: "100%",
        theme: "bootstrap"
      });
    });
  },
  watch: {
    value: function(value) {
      // update value
      $(this.$el)
        .val(value)
        .trigger("change");
    },
    options: function(options) {
      // update options
      $(this.$el)
        .empty()
        .select2({ data: options });
    }
  },
  destroyed: function() {
    $(this.$el)
      .off()
      .select2("destroy");
  }
};
</script>