var hooks = require('hooks');
var crypto = require('crypto');
var moment = require('moment');
var before = require('hooks').before;
var datetime_pattern = /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}[A-Z]/g;

// Signs requests with HMAC authentication strategy
hooks.beforeEach(function (transaction) {
  var client = "WEB";
  var secret  = "a50c25d8cc814f1a476a1b37c88079fe9077eeaa8de408bdcb16b1d8d8cc9214";
  var content_type = transaction.request['headers']['Content-Type'];
  var method = transaction.request.method;
  var path = transaction.request.uri;
  var body = transaction.request.body.replace(/[\n]/g, "\r\n");
  var content_md5 = crypto.createHash("md5").update(body).digest("base64");
  var date = moment().utc().format("ddd, DD MMM YYYY HH:mm:ss") + " GMT";
  var canonical_string = [method, content_type, content_md5, path, date].join();
  var auth_header = "APIAuth " + client + ":" + crypto.createHmac("sha1", secret).update(canonical_string).digest("base64");

  transaction.request.headers["Content-MD5"] = content_md5;
  transaction.request.headers["DATE"] = date;
  transaction.request.headers["Authorization"] = auth_header;
  transaction.request.body = body;
});
hooks.afterEach(function (transaction, done) {
  var body;

  body = transaction.test.actual.body;
  if (typeof body !== 'undefined') {
    transaction.test.actual.body = body.replace(datetime_pattern, "2017-02-12T08:44:42.174Z");
  }
  done();
});
