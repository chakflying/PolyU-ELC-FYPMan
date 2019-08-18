import "../src/alerts.js";
import "../src/bootstrap_forms.js";
import "../src/manage_tables.js";
import "../src/todos.js";
import "../src/turbo-animate.js";

import "bootstrap/dist/js/bootstrap";
import "bootstrap/dist/css/bootstrap.min.css";
require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");
require("datatables.net-bs4");
require("datatables.net-responsive-bs4");
import "datatables.net-bs4/css/dataTables.bootstrap4.css";
import "datatables.net-responsive-bs4/css/responsive.bootstrap4.css";

import "shards-ui/dist/css/shards.min.css";
import "shards-ui/dist/js/shards.min";

import LogRocket from "logrocket";
LogRocket.init("tv4tfc/polyufypman-staging", {
  shouldCaptureIP: false,
  dom: {
    isEnabled: true
  },
  network: {
    requestSanitizer: function(request) {
      if (request.url.toLowerCase().indexOf("login") !== -1) {
        request.body = null;
      } else if (request.url.toLowerCase().indexOf("password_resets") !== -1) {
        request.body = null;
      } else if (request.url.toLowerCase().indexOf("users") !== -1 && request.method == "POST") {
        request.body = null;
      }
      request.headers["X-CSRF-Token"] = null;
      return request;
    }
  }
});
