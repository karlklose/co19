/*
 * Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion In a migrated library, override checking must check that an
 * override is consistent with all overridden methods from other migrated
 * libraries in the super-interface chain, since a legacy library is permitted
 * to override otherwise incompatible signatures for a method.
 *
 * @description Check that if opted-in class implements two classes with some
 * method (one is legacy), migrated method with required non-nullable parameter
 * cannot override legacy method with named parameter (which is nullable) with
 * default value.
 * @Issue 39678
 *
 * @author iarkh@unipro.ru
 */
// SharedOptions=--enable-experiment=non-nullable

import "../../Utils/expect.dart";
import "override_checking_legacy_lib.dart";

abstract class B {
  void test_default({required int i}) {}
  void test_nondefault({required int i}) {}
}

class A implements B, LEGACY_REQUIRED_ARGS {
  void test_default({required int i}) {}
//     ^^^^^^^^^^^^
// [analyzer] unspecified
// [cfe] unspecified

  void test_nondefault({required int i}) {}
//     ^^^^^^^^^^^^^^^
// [analyzer] unspecified
// [cfe] unspecified
}

main() {
  A().test_default(i: 1);
  A().test_nondefault(i: 1);
}