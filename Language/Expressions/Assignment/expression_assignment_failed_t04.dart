/*
 * Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion Evaluation of an assignment of the form e1.v = e2 proceeds as
 * follows:
 * ...
 * If the setter lookup has failed, then a new instance im of the predefined
 * class Invocation is created, such that :
 *  • im.isSetter evaluates to true.
 *  • im.memberName evaluates to the symbol v=.
 *  • im.positionalArguments evaluates to an immutable list with the same values
 *  as [o2].
 *  • im.namedArguments evaluates to the value of const fg.
 *  Then the method noSuchMethod() is looked up in o1 and invoked with
 *  argument im. However, if the implementation found cannot be invoked with
 *  a single positional argument, the implementation of noSuchMethod() in class
 *  Object is invoked on o1
 * @description Checks that it is a static warning is e1 declares only getter
 * for v and that such code results in a NoSuchMethodError. Test the case
 * when e1 is a static type literal
 * @static-warning
 * @author msyabro
 * @issue 14519
 */
import '../../../Utils/expect.dart';

class C {
  static get v  {}
}

main() {
  Expect.throws(() {
    C.v = 2;  /// static type warning
  }, (e) => e is NoSuchMethodError);
}