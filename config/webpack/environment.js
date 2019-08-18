const { environment } = require("@rails/webpacker");
const { VueLoaderPlugin } = require("vue-loader");
const vue = require("./loaders/vue");
const webpack = require("webpack");

environment.plugins.prepend("VueLoaderPlugin", new VueLoaderPlugin());
environment.plugins.append(
  "Provide",
  new webpack.ProvidePlugin({
    $: "jquery",
    jQuery: "jquery",
    Popper: ['popper.js', 'default']
  })
);

environment.loaders.prepend("vue", vue);

environment.loaders.get("sass").use.splice(-1, 0, {
  loader: "resolve-url-loader"
});

module.exports = environment;
