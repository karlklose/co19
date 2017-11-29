/*
 * Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion void addCredentials(
 *  Uri url,
 *  String realm,
 *  HttpClientCredentials credentials
 *  )
 * Add credentials to be used for authorizing HTTP requests.
 * @description Checks that this method adds credentials to be used for
 * authorizing HTTP requests.  Test wrong url argument
 * @author sgrekhov@unipro.ru
 */
import "dart:io";
import "dart:convert";
import "../../../Utils/expect.dart";
import "../../../Utils/async_utils.dart";

var localhost = InternetAddress.LOOPBACK_IP_V4.address;

test() async {
  HttpServer server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 0);
  server.listen((HttpRequest request) {
    var response = request.response;
    Expect.isNull(request.headers[HttpHeaders.AUTHORIZATION]);
    response.close();
    server.close();
    asyncEnd();
  });

  HttpClient client = new HttpClient();
  client.addCredentials(Uri.parse("http://dartlang.org/xxx"),
      "realm", new HttpClientBasicCredentials("co19-test", "password"));

  client.getUrl(Uri.parse("http://${localhost}:${server.port}/xxx"))
    .then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) {
      response.transform(UTF8.decoder).listen((content) {
      });
    });
}

main() {
  asyncStart();
  test();
}