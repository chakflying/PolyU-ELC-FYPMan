<template>
  <div class="row" id="assign">
    <div class="col-sm-3"></div>
    <div class="col-sm-6">
        <label for="student_netID">Assign student(s):</label>
        <template v-for="student_netID_item in student_netID_set">
            <div class="row form-group">
                <input v-model="student_netID_response[student_netID_item]" type="text" class="form-control col-sm-7" placeholder="Student netID">
                <div class="col-sm-5" style="padding-top: 0.3em">text here</div>
            </div>
        </template>
        <button v-on:click="add_student_field()" class="btn btn-secondary">Add another student</button>
        <br>
        <br>
        <label for="student_netID">to supervisor:</label>
        <div class="row form-group">
            <input v-model="supervisor_netID_response[1]" v-on:input="clearError($event)" type="text" class="form-control col-sm-7" placeholder="Supervisor netID" id="assign_sup_field">
            <div class="col-sm-5" style="padding-top: 0.3em">text here</div>
        </div>
        <button v-on:click="submit()" class="btn btn-primary" id="assign_submit_btn">Submit</button>
    </div>
    <div class="col-sm-3"></div>
    <!-- <input class="" v-model="message" placeholder="edit me"> -->
  </div>
</template>

<script>
export default {
    data: function () {
        return {
        message: "Vue.js is working.",
        student_netID_set: [1],
        student_netID_count: 1,
        student_netID_response: {},
        supervisor_netID_response: {},
        }
    },
    methods: {
        onEnlargeText: function (enlargeAmount) {
            this.postFontSize += enlargeAmount
        },
        add_student_field: function () {
            // console.log("add_student_field called");
            this.student_netID_count++;
            // console.log("count is  " + this.student_netID_count);
            // this.student_netID_set[this.student_netID_count] = this.student_netID_count;
            this.student_netID_set.push(this.student_netID_count);
            // this.student_netID_set.pop();
            // console.log(this.student_netID_set);
        },
        clearError: function (event) {
            event.target.classList.remove('is-invalid');
        },
        submit: function () {
            document.getElementById("assign_submit_btn").classList.add('disabled');
            if(!(this.supervisor_netID_response[1])) {
                document.getElementById("assign_sup_field").classList.add('is-invalid');
                document.getElementById("assign_submit_btn").classList.remove('disabled');
                return 0;
            }
            var csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            this.$http.post('/assign', {supervisor_netID: this.supervisor_netID_response, student_netID: this.student_netID_response}, {headers: {'X-CSRF-Token': csrfToken}}).then(response => {
                // get status
            response.status;
            if(response.body == "submitted") {
                Turbolinks.visit(window.location);
            }

            // get status text
            response.statusText;

            // get 'Expires' header
            response.headers.get('Expires');

            // get body data
            console.log(response.body);

        }, response => {
            // error callback
        });
            document.getElementById("assign_submit_btn").classList.remove('disabled');
        }
    }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>