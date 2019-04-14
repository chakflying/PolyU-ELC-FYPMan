<template>
  <div class="row" id="assign">
    <div class="col-lg-3"></div>
    <div class="col-lg-6">
      <label for="student_netID">Assign student(s):</label>
      <template v-for="student_item in student_fields">
        <div class="form-group" :key="student_item">
          <v-select :options="students" v-model="student_netID_response[student_item]" placeholder="Search or Select..."></v-select>
        </div>
      </template>
      <button v-on:click="add_student_field()" class="btn btn-secondary">
        <i class="fas fa-plus" style="font-size:79%"></i>&nbsp;Add another student
      </button>
      <br>
      <br>
      <label for="student_netID">to supervisor:</label>
      <div class="form-group">
        <v-select :options="supervisors" v-model="supervisor_netID_response[0]" placeholder="Search or Select..."></v-select>
      </div>
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
    clearError: function(event) {
      event.target.classList.remove("is-invalid");
    },
    submit: function() {
      var submit_btn = document.getElementById("assign_submit_btn");
      submit_btn.classList.add("disabled");
      if (!this.supervisor_netID_response[0]) {
        submit_btn.classList.remove("disabled");
        return 0;
      }
      var csrfToken = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");
      var post_sups = this.supervisor_netID_response.map(obj => {
        return obj.value;
      });
      var post_stus = this.student_netID_response.map(obj => {
        return obj.value;
      });
      this.$http
        .post(
          "/assign",
          {
            supervisor_netID: post_sups,
            student_netID: post_stus
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
