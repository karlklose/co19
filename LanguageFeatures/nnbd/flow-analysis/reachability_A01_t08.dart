/*
 * Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion Variable or getter: If N is an expression of the form x where the
 * type of x is T then:
 *
 * If T <: Never then:
 *  Let null(N) = unreachable(before(N)).
 *  Let notNull(N) = unreachable(before(N)).
 * Otherwise if T <: Null then:
 *  Let null(N) = before(N).
 *  Let notNull(N) = unreachable(before(N)).
 * Otherwise if T is non-nullable then:
 *  Let null(N) = unreachable(before(N)).
 *  Let notNull(N) = before(N).
 *
 * @description Checks reachability after variable or getter. Test non-nullable
 * type
 *
 * @author sgrekhov@unipro.ru
 * @issue 41981
 */
// SharedOptions=--enable-experiment=non-nullable
// Requirements=nnbd-strong

main() {
  late int i;
  String s = "";
  if (s == null) {
    i = 42; // Variable is initialized in a dead code. This leaves it definitely unassigned
  }
  i;  // It is an error to read a local late variable when it is definitely unassigned.
//^
// [analyzer] unspecified
// [cfe] unspecified
}