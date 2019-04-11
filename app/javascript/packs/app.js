import LogRocket from "logrocket";
LogRocket.init("tv4tfc/polyufypman-staging", {
  shouldCaptureIP: false,
  dom: {
    isEnabled: true,
  },
  network: {
    requestSanitizer: function (request) {
      if (request.url.toLowerCase().indexOf('login') !== -1) {
        request.body = null;
      }
      else if (request.url.toLowerCase().indexOf('password_resets') !== -1) {
        request.body = null;
      }
      else if (request.url.toLowerCase().indexOf('users') !== -1 && request.method == 'POST') {
        request.body = null;
      }
      request.headers['X-CSRF-Token'] = null;
      return request;
    },
  }
});
