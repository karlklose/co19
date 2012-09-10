/*
 * Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion An interface can specify the signatures of constructors that are used 
 * to provide objects that conform to the interface. It is a compile-time error if an
 * interface declares a constructor without declaring a factory class.
 * @description Checks that it is a compile-time error if an interface declares several
 * constructors with the same name, irrespective of their parameters.
 * @compile-error
 * @author vasya
 * @reviewer rodionov
 */

interface I<T> {
  I();
  I(T t);
}

class A implements I {}

main() {
  try {
    new A();
  } catch(e) {}
}

