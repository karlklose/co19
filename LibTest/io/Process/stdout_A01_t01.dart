/*
 * Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion  Stream<List<int>> stdout
 *
 * Returns the standard output stream of the process as a Stream.
 *
 * @description Checks that [stdout] returns Stream<List<int>> value that is the
 * standard output stream of the process as a Stream.
 * @author ngl@unipro.ru
 */
import 'dart:convert';
import "dart:io";
import "dart:async";
import "../../../Utils/expect.dart";

String command = "";
List<String> args = new List<String>.empty(growable: true);

void setCommand() {
  command = Platform.resolvedExecutable;
  args = [
    Platform.script.resolve('stream_lib.dart').toFilePath(),
    'Hi, stdout',
    'Hi, stderr'
  ];
}

main() {
  setCommand();
  asyncStart();
  Process.start(command, args).then((Process process) {
    Expect.isTrue(process.stderr is Stream<List<int>>);
    Utf8Decoder decoder = new Utf8Decoder();
    process.stdout.toList().then((List outList) async {
      if (outList.isEmpty) {
        List stderr = await process.stderr.toList();
        Expect.fail("Stdout is empty. Stderr: $stderr");
      }
      String decoded = decoder.convert(outList[0]);
      Expect.isTrue(decoded.contains("Hi, stdout"), "Actual value: $decoded");
      asyncEnd();
    });
  });
}
