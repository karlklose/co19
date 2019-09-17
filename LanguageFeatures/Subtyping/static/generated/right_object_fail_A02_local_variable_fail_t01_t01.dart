/*
 * Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion We say that a type T0 is a subtype of a type T1 (written T0 <: T1)
 * when:
 * Right Object: if T1 is Object then:
 *  - if T0 is an unpromoted type variable with bound B then T0 <: T1 iff
 *      B <: Object
 *  - if T0 is a promoted type variable X & S then T0 <: T1 iff S <: Object
 *  - if T0 is FutureOr<S> for some S, then T0 <: T1 iff S <: Object.
 *  - if T0 is S* for any S, then T0 <: T1 iff S <: T1
 *  - if T0 is Null, dynamic, void, or S? for any S, then the subtyping does not
 *      hold (per above, the result of the subtyping query is false).
 *  - Otherwise T0 <: T1 is true.
 * @description Check that if T0 is a promoted type variable X & S and
 * S is not subtype of Object then T0 is not subtype of Object
 * @author sgrekhov@unipro.ru
 */
/**
 * @description Check that if type T0 is not a subtype of a type T1, then
 * instance of T0 cannot be be assigned to the to local variable of type T1.
 * Assignment to local variable is tested.
 * @compile-error
 * @author sgrekhov@unipro.ru
 * @author ngl@unipro.ru
 */
/*
 * This test is generated from right_object_fail_A02_t01.dart and 
 * local_variable_fail_x01.dart.
 * Don't modify it. If you want to change this file, change one of the files 
 * above and then run generator.dart to regenerate the tests.
 */


// SharedOptions=--enable-experiment=non-nullable
class X {}
class S extends X {}

S t0Instance = new S();
Object t1Instance = new Object();





class LocalVariableTest {
  LocalVariableTest() {
    Object t1 = null;
    t1 = t0Instance; //# 03: compile-time error
  }

  LocalVariableTest.valid() {}

  test() {
    Object t1 = null;
    t1 = t0Instance; //# 04: compile-time error
  }

  static staticTest() {
    Object t1 = null;
    t1 = t0Instance; //# 05: compile-time error
  }
}



test<T>(T t0Instance) {
  if (t0Instance is S?) {
    
  Object t1 = null;
  t1 = t0Instance; //# 01: compile-time error

  bar () {
    Object t1 = null;
    t1 = t0Instance; //# 02: compile-time error
  }
  bar(); //# 02: compile-time error

  new LocalVariableTest(); //# 03: compile-time error
  new LocalVariableTest.valid().test(); //# 04: compile-time error
  LocalVariableTest.staticTest(); //# 05: compile-time error

  }
}

main() {
  test<X>(t0Instance);
}