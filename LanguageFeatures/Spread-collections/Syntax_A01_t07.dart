/*
 * Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion We extend the list grammar to allow spread elements in addition to
 * regular elements:
 * listLiteral:
 *   const? typeArguments? '[' spreadableList? ']'
 *   ;
 *
 *   spreadableList:
 *   spreadableExpression ( ',' spreadableExpression )* ','?
 *   ;
 *
 *   spreadableExpression:
 *   expression |
 *   spread
 *   ;
 *
 *   spread:
 *   ( '...' | '...?' ) expression
 *   ;
 *
 * Instead of [expressionList], this uses a new [spreadableList] rule since
 * [expressionList] is used elsewhere in the grammar where spreads aren't
 * allowed. Each element in a list is either a normal expression or a spread
 * element. If the spread element starts with [...?], it's a null-aware spread
 * element.
 * @description Checks that spreadable element can have type argument
 * @author iarkh@unipro.ru
 */

import "../../Utils/expect.dart";

main() {
  List<int> list1 = [1, 2, 3];

  Expect.listEquals([1, 2, 3], <int>[...list1]);
  Expect.listEquals([1, 2, 3, 12], <int>[...list1, 12]);
  Expect.listEquals([12, 1, 2, 3], <int>[12, ...list1]);
}
