/*
 * Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion It is an error if a potentially non-nullable local variable which
 * has no initializer expression and is not marked late is used before it is
 * definitely assigned
 *
 * @description Check that it is an error if a potentially non-nullable local
 * variable which has no initializer expression and is not marked late is used
 * before it is definitely assigned. Test FutureOr<A*>
 * @author sgrekhov@unipro.ru
 */
// SharedOptions=--enable-experiment=non-nullable
// Requirements=nnbd-weak
import "dart:async";
import "legacy_lib.dart";

class C {
  static void test() {
    FutureOr<A> f1;

    f1.toString();
//  ^^
// [analyzer] unspecified
// [cfe] unspecified
  }

  void test2() {
    FutureOr<A> f1;

    f1.toString();
//  ^^
// [analyzer] unspecified
// [cfe] unspecified
  }
}

main() {
  FutureOr<A> f1;

  f1.toString();
//^^
// [analyzer] unspecified
// [cfe] unspecified

  Function foo = () {
    FutureOr<A> f1;

    f1.toString();
//  ^^
// [analyzer] unspecified
// [cfe] unspecified
  };
  C.test();
  new C().test2();
}
