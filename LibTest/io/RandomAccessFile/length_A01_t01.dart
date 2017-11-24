/*
 * Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion Future<int> length()
 * Gets the length of the file. Returns a Future<int> that completes with the
 * length in bytes.
 *
 * @description Checks that method length returns Future<int> that completes
 * with the length in bytes.
 * @author ngl@unipro.ru
 */
import "dart:async";
import "dart:io";
import "../../../Utils/expect.dart";
import "../../../Utils/async_utils.dart";
import "../file_utils.dart";

void check(int fLen) {
  File file = getTempFileSync();
  asyncStart();
  Future<RandomAccessFile> raFile = file.open(mode: FileMode.WRITE);
  raFile.then((RandomAccessFile rf) {
    Expect.isNotNull(rf);
    for (int i = 0; i < fLen; i++) {
      rf.writeByteSync((i + 1) & 0xff);
    }
    var rfLen = rf.length();
    Expect.isTrue(rfLen is Future<int>);

    rfLen.then((int len) {
      Expect.isTrue(len is int);
      Expect.isTrue(len == fLen);
    });
    asyncEnd();
  }).whenComplete(() {
    file.deleteSync();
  });
}

main() {
  for (int i = 0; i < 10; i++) {
    check(i);
  }
}