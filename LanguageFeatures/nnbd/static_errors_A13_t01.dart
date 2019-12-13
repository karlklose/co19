/*
 * Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion It is an error to call a method, setter, or getter on a receiver
 * of static type Never (including via a null aware operator).
 *
 * @description Check that it is an error to call a method, setter, or getter on
 * a receiver of static type Never (including via a null aware operator).
 * @author sgrekhov@unipro.ru
 */
// SharedOptions=--enable-experiment=non-nullable
// Requirements=nnbd-strong
void test(var x) {
  if (x is Never) {
    x.toString();
//    ^^^^^^^^
// [analyzer] unspecified
// [cfe] unspecified
    x.runtimeType;
//    ^^^^^^^^^^^
// [analyzer] unspecified
// [cfe] unspecified
    x.s = 1;
//   ^^
// [analyzer] unspecified
// [cfe] unspecified
    x?.toString();
//     ^^^^^^^^
// [analyzer] unspecified
// [cfe] unspecified
    x?.runtimeType;
//     ^^^^^^^^^^^
// [analyzer] unspecified
// [cfe] unspecified
    x?.s = 1;
//    ^^
// [analyzer] unspecified
// [cfe] unspecified
    x?..toString();
//      ^^^^^^^^
// [analyzer] unspecified
// [cfe] unspecified
    x?..runtimeType;
//      ^^^^^^^^^^^
// [analyzer] unspecified
// [cfe] unspecified
    x?..s = 1;
//    ^^^
// [analyzer] unspecified
// [cfe] unspecified
  }
}

main() {
  test(null);
}