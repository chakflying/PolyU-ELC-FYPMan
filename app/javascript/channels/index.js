// import consumer from "./consumer";
const channels = require.context(".", true, /_channel\.js$/);
channels.keys().forEach(channels);
