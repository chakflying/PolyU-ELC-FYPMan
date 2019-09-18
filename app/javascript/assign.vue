<template>
  <div class="row" id="assign">
    <div class="col-lg-3"></div>
    <div class="col-lg-6">
      <label>Assign student(s):</label>
      <template v-for="student_item in student_fields">
        <div class="form-group" :key="'stu'+student_item">
          <v-select
            :options="students"
            :reduce="student => student.value"
            v-model="student_netID_response[student_item]"
            placeholder="Search or Select..."
          ></v-select>
        </div>
      </template>
      <button v-on:click="add_student_field()" class="btn btn-secondary">
        <i class="fas fa-plus" style="font-size:79%"></i>&nbsp;Add another student
      </button>
      <br />
      <br />
      <label>to supervisor(s):</label>
      <template v-for="supervisor_item in supervisor_fields">
        <div class="form-group" :key="'sup'+supervisor_item">
          <v-select
            :options="supervisors"
            :reduce="supervisor => supervisor.value"
            v-model="supervisor_netID_response[supervisor_item]"
            placeholder="Search or Select..."
          ></v-select>
        </div>
      </template>
      <button v-on:click="add_supervisor_field()" class="btn btn-secondary">
        <i class="fas fa-plus" style="font-size:79%"></i>&nbsp;Add another supervisor
      </button>
      <br />
      <br />
      <button
        v-on:click="submit()"
        class="btn btn-primary"
        id="assign_submit_btn"
        aria-label="Submit"
      >Submit</button>
    </div>
    <div class="col-lg-3"></div>
  </div>
</template>

<script>
export default {
  props: ["students", "supervisors"],
  data: function() {
    return {
      student_fields: [0],
      supervisor_fields: [0],
      student_netID_response: [],
      supervisor_netID_response: []
    };
  },
  methods: {
    onEnlargeText: function(enlargeAmount) {
      this.postFontSize += enlargeAmount;
    },
    add_student_field: function() {
      this.student_fields.push(this.student_fields.length);
    },
    add_supervisor_field: function() {
      this.supervisor_fields.push(this.supervisor_fields.length);
    },
    clearError: function(event) {
      event.target.classList.remove("is-invalid");
    },
    submit: function() {
      var submit_btn = document.getElementById("assign_submit_btn");
      submit_btn.classList.add("disabled");
      if (
        !this.supervisor_netID_response[0] ||
        !this.student_netID_response[0]
      ) {
        submit_btn.classList.remove("disabled");
        return;
      }
      var csrfToken = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");
      this.$http
        .post(
          document.root_postfix + "/assign",
          {
            supervisor_netID: this.supervisor_netID_response,
            student_netID: this.student_netID_response
          },
          { headers: { "X-CSRF-Token": csrfToken } }
        )
        .then(
          response => {
            // get status
            response.status;
            if (response.body == "submitted") {
              Turbolinks.visit(window.location);
            }
            // get status text
            response.statusText;
          },
          response => {
            // error callback
          }
        );
      submit_btn.classList.remove("disabled");
    }
  }
};
</script>

<style lang="scss">
@import "vue-select/dist/vue-select.css";
</style>
