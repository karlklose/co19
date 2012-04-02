/*
 * Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion Evaluation of a logical boolean expression b of the form e1&&e2 causes the
 * evaluation of e1; if e1 does not evaluate to true, the result of evaluating b
 * is false, otherwise e2 is evaluated to an object o, which is then subjected to
 * boolean conversion producing an object r, which is the value of b.
 * @description Checks that the second operand is not evaluated if the first operand
 * evaluates to false.
 * @static-warning
 * @author msyabro
 * @reviewer kaigorodov
 */

main() {
  false && (Expect.fail("This operand should not be evaluated"));
}