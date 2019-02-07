import LogRocket from "logrocket";
LogRocket.init("tv4tfc/polyufypman-staging", {
  shouldCaptureIP: false,
  network: {
    requestSanitizer: function (request) {
      if (request.url.toLowerCase().indexOf('login') !== -1) {
        request.body = null;
      }
      request.headers['X-CSRF-Token'] = null;
      return request;
    },
  }
});
