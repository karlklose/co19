/*
 * Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion If a name N is referenced by a library L and N is introduced into the top
 * level scope L by more than one import then:
 * - A static warning occurs.
 * - If N is referenced as a function, getter or setter, a NoSuchMethodError is raised.
 * - If N is referenced as a type, it is treated as a malformed type.
 * It is neither an error nor a warning if N is introduced by two or more imports
 * but never referred to.
 * @static-warning
 * @description Checks that it is a static warning if a library is imported twice
 * with empty prefixes and introduces a type name to the top level scope of A,
 * which A uses in a static getter invocation expression.
 * @author rodionov
 * @reviewer kaigorodov
 */

import "1_Imports_A03_t61_lib.dart";
import "1_Imports_A03_t61_lib.dart";

main() {
  try {
    Bar.BAR;
  } catch(anything) {}
}
