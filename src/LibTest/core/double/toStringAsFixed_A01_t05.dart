/*
 * Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion String toStringAsFixed(int fractionDigits)
 * @description Checks that the exception is thrown when 'fractionDigits' is negative.
 * @author pagolubev
 * @reviewer msyabro
 * @needsreview Exception type?
 */


main() {
  bool fail = false;
  try {
    .1.toStringAsFixed(-1);
    fail = true;
  } catch(e) {}
  if(fail) {
    Expect.fail("Expected exception");
  }
}
