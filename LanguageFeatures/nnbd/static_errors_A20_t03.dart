/*
 * Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion It is a warning to use a null aware operator (?., ?.., ??, ??=,
 * or ...?) on a non-nullable receiver.
 *
 * @description Check it is a warning to use a null aware operator (?., ?.., ??,
 * ??=, or ...?) on a non-nullable receiver. Test type aliases
 * @author sgrekhov@unipro.ru
 */
// SharedOptions=--enable-experiment=non-nullable,nonfunction-type-aliases
class A {
  test() {}
}

class C extends A {}

typedef CAlias = C;

main() {
  A a = A();
  CAlias c = C();
  c?.test();                                //# 01: static-type warning
  c?..test();                               //# 02: static-type warning
  c ?? a;                                   //# 03: static-type warning
  a ??= c;                                  //# 04: static-type warning
  List<CAlias?> clist = [C(), C(), null];   //# 05: static-type warning
  List<A> alist = [A(), C(), ...? clist];   //# 06: static-type warning
}