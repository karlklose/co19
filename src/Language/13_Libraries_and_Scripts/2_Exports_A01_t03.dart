/*
 * Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion 
 * libraryExport:
 *   metadata export uri combinator* `;'
 * ; 
 * @description Checks that it is not an error when the identifiers used with show/hide combinators 
 * are also named 'hide' and 'show', and that filtering the export namespace is done correctly.
 * @author rodionov
 * @reviewer kaigorodov
 */

import "2_Exports_A01_t03_lib.dart";

main() {
  Expect.equals(hide, "hide");
  Expect.equals(show, "show");

  try {
    var x = foo;
    Expect.fail("NoSuchMethodError expected");
  } on NoSuchMethodError catch(ok) {}
}
