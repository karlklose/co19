/*
 * Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion E reduce(E combine(E value, E element))
 * ...
 * If it has only one element, that element is returned.
 * @description Checks that if iterable has only one element, that element is
 * returned.
 * @author ngl@unipro.ru
 */

import "dart:typed_data";
import "../../../Utils/expect.dart";

check(List<int> list, int expected) {
  var l = new Uint32List.fromList(list);
  var res = l.reduce((prev, cur) => prev + cur);
  Expect.equals(expected, res);
}

checkConst(List<int> list, int expected) {
  var l = new Uint32List.fromList(list);
  var res = l.reduce((prev, cur) => 1);
  Expect.equals(expected, res);
}

main() {
  check([10], 10);
  check([1], 1);

  checkConst([3], 3);
}
