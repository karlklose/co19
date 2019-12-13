/*
 * Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion In an unmigrated library, override checking is done using legacy
 * types. This means that an unmigrated library can bring together otherwise
 * incompatible methods. When choosing the most specific signature during
 * interface computation, all nullability and requiredness annotations are
 * ignored, and the [Never] type is treated as [Null].
 *
 * @description Check that if legacy class extends opted-in class, all
 * nullability annotations in the parent class are ignored in the child class
 * type parameters.
 *
 * @author iarkh@unipro.ru
 */
// SharedOptions=--enable-experiment=non-nullable
// @dart=2.4

import "../../Utils/expect.dart";
import "override_checking_opted_in_lib.dart";

class D1<X extends A> extends D<X> {}
class E1<X extends A> extends E<X> {}

main() {
  D<A> d = D<A>();
  Expect.equals(A, d.getParamType());

  E<A> e = E<A>();
  Expect.equals(A, e.getParamType());

  D1<A> d1 = D1<A>();
  Expect.equals(A, d1.getParamType());

  E1<A> e1 = E1<A>();
  Expect.equals(A, e1.getParamType());
}