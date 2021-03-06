/*
 * Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion A mixin declaration defines an interface. The interface for this
 * mixin declaration is equivalent to the interface of the class declared as:
 *  abstract class A<X extends S, Y extends T> extends A$super<X, Y>
 *    implements D, E { body' }
 * where body' contains abstract declarations corresponding to the instance
 * members of body of the mixin A.
 * It is a compile time error for the mixin declaration if this class
 * declarations would not be valid.
 *
 * @description Checks that it is a compile-time error for the mixin declaration
 * if classes from on clause and implements clause are not compatible.
 * @compile-error
 * @author ngl@unipro.ru
 */

class T1 {}
class T2 {}

abstract class I1 {
  T1 get n;
}
abstract class I2 {
  T2 n(T2 p);
}
abstract class I3 {
  T2 n(T1 p);
}
class J {}

class B {}
abstract class C1 {
  T2 get n;
}
abstract class C2 {
  T1 n(T1 p);
}
abstract class C3 {
  T2 n(T2 p1, T1 p2);
}

// The same name getters with different return types
mixin M1 on B, C1 implements I1, J {}  //# 01: compile-time error

// The same name getter and method with the same return types
mixin M2 on B, C2 implements I1, J {} //# 02: compile-time error

// The same name methods with different return types
mixin M3 on B, C2 implements I2, J {} //# 03: compile-time error

// The methods with the same return types and different parameters number
mixin M4 on B, C3 implements I3, J {} //# 04: compile-time error

main() {
}
