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
            <input type="text" id="supervisor_netID" class="form-control col-sm-7" placeholder="Supervisor netID" name="student_netID">
            <div class="col-sm-5" style="padding-top: 0.3em">text here</div>
        </div>
        <button v-on:click="submit()" class="btn btn-primary">Submit</button>
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
        student_netID_set: [{1:null}],
        student_netID_count: 1,
        student_netID_response: {},
        }
    },
    methods: {
        onEnlargeText: function (enlargeAmount) {
            this.postFontSize += enlargeAmount
        },
        add_student_field: function () {
            console.log("add_student_field called");
            console.log(this.student_netID_set);
            this.student_netID_count += 1;
            this.student_netID_set[this.student_netID_count] = null;
            this.student_netID_set.push();
            this.student_netID_set.pop();
        },
        submit: function () {

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