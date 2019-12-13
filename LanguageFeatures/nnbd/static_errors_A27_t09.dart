/*
 * Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion It is a warning to use the null check operator (!) on a
 * non-nullable expression.
 *
 * @description Check that it is a warning to use the null check operator (!) on
 * a non-nullable expression. Test FutureOr<Function>
 * @author sgrekhov@unipro.ru
 * @issue 39598
 */
// SharedOptions=--enable-experiment=non-nullable
import "dart:async";

void foo() {}

main() {
  FutureOr<Function> f = foo;
  f!;     //# 01: static type warning
}