<template>
  <div id="create-group container-fluid" :key="formKey">
    <div class="row">
      <div class="col-lg-2 col-12 form-group">
        <label>Group Number:</label>
        <input
          type="text"
          class="form-control"
          v-model="newGroupNumber"
          aria-describedby="groupNumberHelp"
          placeholder="Group Number"
          v-bind:class="{ 'is-invalid': newGroupNumberError }"
          v-on:change="checkGroupNumber"
        />
        <small id="groupNumberHelp" class="form-text text-muted">Optional.</small>
      </div>
      <div class="col-lg-5 col-12 form-group">
        <label>Student(s):</label>
        <v-select
          :options="students"
          :reduce="student => student.value"
          v-model="student_ids"
          :selectOnTab="true"
          :multiple="true"
          :closeOnSelect="false"
          placeholder="Search or Select..."
        ></v-select>
        <small id="studentsHelp" class="form-text text-muted">Continue typing to add more students.</small>
      </div>
      <div class="col-lg-5 col-12 form-group">
        <label>Supervisor(s):</label>
        <v-select
          :options="supervisors"
          :reduce="supervisor => supervisor.value"
          v-model="supervisor_ids"
          :selectOnTab="true"
          :multiple="true"
          :closeOnSelect="false"
          placeholder="Search or Select..."
        ></v-select>
      </div>
    </div>
    <div class="row">
      <div class="col-2">
        <button
          v-on:click="submit()"
          class="btn btn-primary"
          id="create_group_submit_btn"
          aria-label="Submit"
          v-html="button.text"
        ></button>
      </div>
      <div class="col-10">
        <div
          class="p-2"
          v-bind:class="{ 'text-success': formSuccess, 'text-danger': formError}"
          v-html="status"
        ></div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ["students", "supervisors"],
  data: function() {
    return {
      student_ids: [],
      supervisor_ids: [],
      newGroupNumber: null,
      newGroupNumberError: false,
      formSuccess: false,
      formError: false,
      button: { text: "Submit" },
      status: "",
      formKey: 0
    };
  },
  methods: {
    checkGroupNumber: function() {
      this.newGroupNumberError = false;
      if (!isFinite(this.newGroupNumber)) {
        this.newGroupNumberError = true;
      }
    },
    onEnlargeText: function(enlargeAmount) {
      this.postFontSize += enlargeAmount;
    },
    clearError: function(event) {
      event.target.classList.remove("is-invalid");
    },
    submit: function() {
      this.formError = false;
      this.formSuccess = false;
      this.status = "";
      var submit_btn = document.getElementById("create_group_submit_btn");
      submit_btn.classList.add("disabled");
      if (!this.student_ids[0] || !isFinite(this.newGroupNumber)) {
        submit_btn.classList.remove("disabled");
        this.formError = true;
        this.status = "Please check your input.";
        return;
      }
      this.button.text = '<i class="fas fa-sync-alt fa-spin"></i>';
      var csrfToken = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");
      this.$http
        .post(
          "/create_group_and_add",
          {
            number: this.newGroupNumber,
            student_ids: this.student_ids,
            supervisor_ids: this.supervisor_ids
          },
          { headers: { "X-CSRF-Token": csrfToken } }
        )
        .then(
          response => {
            // get status
            response.status;
            if (response.body == "submitted") {
              // Turbolinks.visit(window.location);
              this.button.text = "Submit";
              this.status =
                '<i class="fas fa-check mr-2" style="font-size:80%;"></i>Group created successfully.';
              this.formSuccess = true;
              this.formError = false;
              this.student_ids = [];
              this.supervisor_ids = [];
              this.newGroupNumber = null;
              document.groups_dataTable.ajax.reload();
              this.formKey += 1;
            } else {
              this.button.text = "Submit";
              this.formSuccess = false;
              this.formError = true;
              this.status =
                '<i class="fas fa-times mr-2" style="font-size:80%;"></i>Error processing request. Please refresh.';
            }
            // get status text
            response.statusText;
          },
          response => {
            // error callback
            this.button.text = "Submit";
            this.formSuccess = false;
            this.formError = true;
            this.status =
              '<i class="fas fa-times mr-2" style="font-size:80%;"></i>Network error, please try again later.';
          }
        );
      submit_btn.classList.remove("disabled");
    }
  }
};
</script>

<style lang="scss">
@import "vue-select/dist/vue-select.css";
.vs__dropdown-toggle {
  border-radius: 6px;
  border-color: rgb(190, 202, 214);
  padding-top: 3px;
  padding-bottom: 7px;
  transition: box-shadow 250ms cubic-bezier(0.27, 0.01, 0.38, 1.06),
    border 250ms cubic-bezier(0.27, 0.01, 0.38, 1.06);
}

.vs--open .vs__dropdown-toggle {
  border-color: rgb(0, 123, 255) !important;
  box-shadow: 0 0.313rem 0.719rem rgba(0, 123, 255, 0.1),
    0 0.156rem 0.125rem rgba(0, 0, 0, 0.06) !important;
}

.vs__dropdown-menu {
  border-color: rgb(0, 123, 255) !important;
}

.vs__selected {
  color: #495057;
  background-color: #e9ecef;
  border: 0;
  line-height: 1.5;
  padding: 2px 7px 3px 7px;
  margin: 3px 5px 0 2px;
  font-size: 0.85em;
}

.vs__open-indicator {
  margin-top: 3px;
}

.vs__deselect {
  padding-top: 3px;
}

.gp-add-mem-item .v-select {
  margin-left: 8px;
  margin-right: 8px;
  font-size: 85%;
}
</style>
