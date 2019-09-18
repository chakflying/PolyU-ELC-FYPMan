<template>
  <div class="gp-add-mem-item" style="width:350px;margin:0.3em 0.3em 0.1em 0.3em;">
    <div class="row justify-content-center">
      <div class="col-12" @click.stop="stopClick" v-if="student_showing">
        <v-select
          :options="students"
          :reduce="student => student.value"
          v-model="student_id"
          :selectOnTab="true"
          :closeOnSelect="true"
          placeholder="Add Student:"
          v-on:input="submitStudent"
        ></v-select>
      </div>
      <div v-else class="col-2" v-html="student_status"></div>
    </div>
    <div class="row justify-content-center">
      <div class="col-12" @click.stop="stopClick" v-if="supervisor_showing">
        <v-select
          :options="supervisors"
          :reduce="supervisor => supervisor.value"
          v-model="supervisor_id"
          :selectOnTab="true"
          :closeOnSelect="true"
          placeholder="Add Supervisor:"
          v-on:input="submitSupervisor"
        ></v-select>
      </div>
      <div v-else class="col-2" v-html="supervisor_status"></div>
    </div>
  </div>
</template>

<script>
export default {
  props: ["group_id", "students", "supervisors"],
  data: function() {
    return {
      student_showing: true,
      student_id: null,
      student_status:
        '<div class="spinner-border spinner-border-sm" role="status"><span class="sr-only">Loading...</span></div>',
      supervisor_showing: true,
      supervisor_id: null,
      supervisor_status:
        '<div class="spinner-border spinner-border-sm" role="status"><span class="sr-only">Loading...</span></div>'
    };
  },
  methods: {
    submitStudent: function() {
      this.student_showing = false;
      var csrfToken = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");
      this.$http
        .post(
          document.root_postfix + "/groups_students",
          {
            group_id: this.$props.group_id,
            student_id: this.student_id
          },
          { headers: { "X-CSRF-Token": csrfToken } }
        )
        .then(
          response => {
            // get status
            console.log(response.status);
            if (response.body == "submitted") {
              // Turbolinks.visit(window.location);
              document.groups_dataTable.ajax.reload();
            } else {
              this.student_status =
                '<i class="fas fa-times mr-2" style="font-size:80%;"></i>';
            }
          },
          response => {
            // error callback
            this.student_status =
              '<i class="fas fa-times mr-2" style="font-size:80%;"></i>';
          }
        );
    },
    submitSupervisor: function() {
      this.supervisor_showing = false;
      var csrfToken = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");
      this.$http
        .post(
          document.root_postfix + "/groups_supervisors",
          {
            group_id: this.$props.group_id,
            supervisor_id: this.supervisor_id
          },
          { headers: { "X-CSRF-Token": csrfToken } }
        )
        .then(
          response => {
            // get status
            console.log(response.status);
            if (response.body == "submitted") {
              // Turbolinks.visit(window.location);
              document.groups_dataTable.ajax.reload();
            } else {
              this.supervisor_status =
                '<i class="fas fa-times mr-2" style="font-size:80%;"></i>';
            }
          },
          response => {
            // error callback
            this.supervisor_status =
              '<i class="fas fa-times mr-2" style="font-size:80%;"></i>';
          }
        );
    },
    stopClick: function() {}
  }
};
</script>

<style lang="scss">
.gp-add-mem-item .row {
  height: 2.5em;
  margin-top: 0.3em;
  margin-bottom: 0.3em;
}
</style>