/*
 * Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion bool isDirectorySync(String path)
 * Synchronously checks if typeSync(path) returns
 * FileSystemEntityType.DIRECTORY.
 *
 * @description Checks that this property Synchronously checks if typeSync(path)
 * returns FileSystemEntityType.DIRECTORY. Test Directory
 * @author sgrekhov@unipro.ru
 */
import "dart:io";
import "../../../Utils/expect.dart";
import "../../../Utils/file_utils.dart";

main() {
  Directory dir = getTempDirectorySync();
  try {
    Expect.isTrue(FileSystemEntity.isDirectorySync(dir.path));
    Expect.equals(
        FileSystemEntity.typeSync(dir.path), FileSystemEntityType.DIRECTORY);
  } finally {
    dir.delete();
  }
}
