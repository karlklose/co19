/*
 * Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion In strong checking mode, all generic const constructors and
 * generic const literals are evaluated using the actual type arguments
 * provided, whether legacy or non-legacy. This ensures that in strong checking
 * mode, the final consistent semantics are obeyed.
 *
 * @description Checks dynamically that actual generic class type parameter is
 * evaluated correctly for [Object?] type argument.
 *
 * @issue 39678
 * @author iarkh@unipro.ru
 */
// SharedOptions=--enable-experiment=non-nullable
// Requirements=nnbd-strong

import "../../Utils/expect.dart";

class A<T> {
  const A();
  void testme() { Expect.equals(typeOf<Object?>(), T); }
}

main() {
  const a = A<Object?>();
  a.testme();
}