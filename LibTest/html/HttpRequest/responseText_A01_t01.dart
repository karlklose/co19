/*
 * Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion final String responseText
 * The response in String form or empty String on failure.
 * @description Checks that the property is not empty in case of success.
 */
import "dart:html";
import "dart:async";
import "../../../Utils/expect.dart";

main() {
  asyncStart();
  Future<HttpRequest> f = HttpRequest.request("test.html");
  f.then((HttpRequest r) {
    Expect.isNotNull(r.responseText?.length);
    Expect.isTrue(r.responseText!.length > 0);
    asyncEnd();
  }, onError: (Object error) {
    Expect.fail("request.onLoad.listen:onError($error)");
  });
}
