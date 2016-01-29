/*
 * Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion Evaluation of an assignment a of the form v = e proceeds as
 * follows:
 * Let d be the innermost declaration whose name is v or v =, if it exists.
 * ...
 * Otherwise, If a occurs inside a top level or static method (be it function,
 * method, getter, or setter) or variable initializer, evaluation of a causes e
 * to be evaluated, after which a NoSuchMethodError is thrown.
 * @description Checks that if a inside a static method then evaluation of
 * a causes e to be evaluated, after which a NoSuchMethodError is thrown.
 * @author sgrekhov@unipro.ru
 */
import '../../../Utils/expect.dart';

bool evaluated = false;

int e() {
  evaluated = true;
  return 0;
}

class C {
  static void f() {
    Expect.throws(() {v = e();}, (e) => e is NoSuchMethodError); /// static type warning
  }
}

main() {
  C.f();
  Expect.isTrue(evaluated);
}