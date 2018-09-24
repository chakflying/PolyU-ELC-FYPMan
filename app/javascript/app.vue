<template>
  <div id="app">
    <h1 class="display-5 text-center">{{ message }}</h1>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      message: ""
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
