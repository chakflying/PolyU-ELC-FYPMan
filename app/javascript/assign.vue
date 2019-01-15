<template>
  <div class="row" id="assign">
    <div class="col-md-3"></div>
    <div class="col-md-6">
      <label for="student_netID">Assign student(s):</label>
      <template v-for="student_item in student_set">
        <div class="form-group">
          <AssignSelect2 :options="students" v-model="student_netID_response[student_item]"></AssignSelect2>
        </div>
      </template>
      <button v-on:click="add_student_field()" class="btn btn-secondary">
        <i class="fas fa-plus" style="font-size:79%"></i>&nbsp;Add another student
      </button>
      <br>
      <br>
      <label for="student_netID">to supervisor:</label>
      <div class="form-group">
        <AssignSelect2 :options="supervisors" v-model="supervisor_netID_response[1]"></AssignSelect2>
      </div>
      <button
        v-on:click="submit()"
        class="btn btn-primary"
        id="assign_submit_btn"
        aria-label="Submit"
      >Submit</button>
    </div>
    <div class="col-md-3"></div>
  </div>
</template>

<script>
import AssignSelect2 from "./assign-select2.vue";
export default {
  components: {
    AssignSelect2
  },
  props: ["students", "supervisors"],
  data: function() {
    return {
      student_set: [1],
      student_name: [null],
      supervisor_name: "",
      student_count: 1,
      student_netID_response: {},
      supervisor_netID_response: {}
    };
  },
  methods: {
    onEnlargeText: function(enlargeAmount) {
      this.postFontSize += enlargeAmount;
    },
    add_student_field: function() {
      // console.log("add_student_field called");
      this.student_count++;
      // console.log("count is  " + this.student_netID_count);
      // this.student_netID_set[this.student_netID_count] = this.student_netID_count;
      this.student_set.push(this.student_count);
      this.student_name.push(null);
      // this.student_netID_set.pop();
      // console.log(this.student_netID_set);
    },
    clearError: function(event) {
      event.target.classList.remove("is-invalid");
    },
    submit: function() {
      document.getElementById("assign_submit_btn").classList.add("disabled");
      if (!this.supervisor_netID_response[1]) {
        document
          .getElementById("assign_submit_btn")
          .classList.remove("disabled");
        return 0;
      }
      var csrfToken = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");
      this.$http
        .post(
          "/assign",
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

            // get 'Expires' header
            response.headers.get("Expires");

            // get body data
            // console.log(response.body);
          },
          response => {
            // error callback
          }
        );
      document.getElementById("assign_submit_btn").classList.remove("disabled");
    }
  },
  mounted: function() {
    FontAwesome.dom.i2svg();
  },
  updated: function() {
    FontAwesome.dom.i2svg();
  }
};
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>