/*
 * Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion A type T0 is a subtype of a type T1 (written T0 <: T1) when:
 * Named Function Types: T0 is U0 Function<X0 extends B00, ..., Xk extends B0k>
 *   (T0 x0, ..., Tn xn, {Tn+1 xn+1, ..., Tm xm})
 *
 * and T1 is U1 Function<Y0 extends B10, ..., Yk extends B1k>(S0 y0, ..., Sn yn,
 * {Sn+1 yn+1, ..., Sq yq})
 * and {yn+1, ... , yq} subsetof {xn+1, ... , xm}
 * and Si[Z0/Y0, ..., Zk/Yk] <: Vi[Z0/X0, ..., Zk/Xk] for i in 0...n
 * and Si[Z0/Y0, ..., Zk/Yk] <: Tj[Z0/X0, ..., Zk/Xk] for i in n+1...q, yj = xi
 * and U0[Z0/X0, ..., Zk/Xk] <: U1[Z0/Y0, ..., Zk/Yk]
 * and B0i[Z0/X0, ..., Zk/Xk] === B1i[Z0/Y0, ..., Zk/Yk] for i in 0...k
 * where the Zi are fresh type variables with bounds B0i[Z0/X0, ..., Zk/Xk]
 * @description Check that if {yn+1, ... , yq} is not subsetof {xn+1, ... , xm},
 * then T0 is not a subtype of T1
 * @author sgrekhov@unipro.ru
 */
import "../utils/common.dart";
import "../../../Utils/expect.dart";

class U0 extends U1 {}
class U1 {}
class B0 {}
class B1 {}
class V0 {}
class V1 {}
class V2 {}
class V3 {}
class V4 {}
class S0 extends V0 {}
class S1 extends V1 {}
class S2 extends V2 {}
class S3 extends V3 {}

class X0 extends B0 {}
class X1 extends B1 {}

class Y0 extends B0 {}
class Y1 extends B1 {}

typedef U0 T0<X0 extends B0, X1 extends B1>(V0 x0, V1 x1, {V2 x2, V3 x3, V4 x4});
typedef U1 T1<Y0 extends B0, Y1 extends B1>(S0 y0, S1 y1, {S2 x2, S3 y3}); // y3 is not x3

U0 t0<X0, X1>(V0 x0, V1 x1, {V2 x2, V3 x3, V4 x4}) => null;
U1 t1<Y0, Y1>(S0 y0, S1 y1, {S2 x2, S3 y3}) => null;

T0 t0Instance = t0;
T1 t1Instance = t1;




class ClassMemberSuper1_t02 {
  T1 m;

  ClassMemberSuper1_t02(dynamic value) {
    m = value;
  }

  ClassMemberSuper1_t02.named(dynamic value) {
    m = value;
  }

  ClassMemberSuper1_t02.short(this.m);

  void set superSetter(T1 val) {}
}

class ClassMember1_t02 extends ClassMemberSuper1_t02 {

  ClassMember1_t02() : super(forgetType(t0Instance)) {}

  ClassMember1_t02.named() : super.named(forgetType(t0Instance)) {}

  ClassMember1_t02.short() : super.short(forgetType(t0Instance));

  ClassMember1_t02.valid() : super(null);

  test1() {
    m = forgetType(t0Instance);
  }

  test2() {
    superSetter = forgetType(t0Instance);
  }
}

class ClassMemberSuper2_t02<X> {
  X m;

  ClassMemberSuper2_t02(X value) {
    m = value;
  }

  ClassMemberSuper2_t02.named(X value) {
    m = value;
  }

  ClassMemberSuper2_t02.short(this.m);

  void set superSetter(X val) {}
}

class ClassMember2_t02<X> extends ClassMemberSuper2_t02<X> {

  ClassMember2_t02() : super(forgetType(t0Instance)) {}

  ClassMember2_t02.named() : super.named(forgetType(t0Instance)) {}

  ClassMember2_t02.short() : super.short(forgetType(t0Instance));

  ClassMember2_t02.valid() : super(null);

  test1() {
    m = forgetType(t0Instance);
  }

  test2() {
    superSetter = forgetType(t0Instance);
  }
}

main() {
  Expect.throws(() {new ClassMember1_t02();}, (e) => e is TypeError);
  Expect.throws(() {new ClassMember1_t02.short();}, (e) => e is TypeError);
  Expect.throws(() {new ClassMember1_t02.named();}, (e) => e is TypeError);
  Expect.throws(() {
    new ClassMember1_t02.valid().m = forgetType(t0Instance);
  }, (e) => e is TypeError);
  Expect.throws(() {
    new ClassMember1_t02.valid().superSetter = forgetType(t0Instance);
  }, (e) => e is TypeError);
  Expect.throws(() {
    new ClassMember1_t02.valid().test1();
  }, (e) => e is TypeError);
  Expect.throws(() {
    new ClassMember1_t02.valid().test2();
  }, (e) => e is TypeError);

  Expect.throws(() {new ClassMember2_t02<T1>();}, (e) => e is TypeError);
  Expect.throws(() {new ClassMember2_t02<T1>.short();}, (e) => e is TypeError);
  Expect.throws(() {new ClassMember2_t02<T1>.named();}, (e) => e is TypeError);
  Expect.throws(() {
    new ClassMember2_t02<T1>.valid().m = forgetType(t0Instance);
  }, (e) => e is TypeError);
  Expect.throws(() {
    new ClassMember2_t02<T1>.valid().superSetter = forgetType(t0Instance);
  }, (e) => e is TypeError);
  Expect.throws(() {
    new ClassMember2_t02<T1>.valid().test1();
  }, (e) => e is TypeError);
  Expect.throws(() {
    new ClassMember2_t02<T1>.valid().test2();
  }, (e) => e is TypeError);
}