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
 * @description Check that when choosing the most specific method signature
 * during interface computation, all nullability annotations are ignored in
 * unmigrated library for the class type parameter ([implements] clause).
 */
// SharedOptions=--enable-experiment=non-nullable
// @dart=2.4

import "../../Utils/expect.dart";
import "override_checking_opted_in_lib.dart";

class D1<X extends A> implements D<X> {}
class E1<X extends A> implements E<X> {}

main() {
  D<Null> d = D<Null>();
  Expect.isTrue(d is D<Null>);

  E<Null> e = E<Null>();
  Expect.isTrue(e is E<Null>);

  D1<Null> d1 = D1<Null>();
  Expect.isTrue(d1 is D1<Null>);

  E1<Null> e1 = E1<Null>();
  Expect.isTrue(e1 is E1<Null>);
}